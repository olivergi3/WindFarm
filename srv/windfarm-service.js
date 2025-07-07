const cds = require('@sap/cds');

// Load environment variables from .env file
require('dotenv').config();

// Function to get authentication token
async function getToken() {
    const url = 'https://btplearning-w4kbx4of.authentication.us10.hana.ondemand.com/oauth/token?grant_type=client_credentials&response_type=token';
    const username = process.env.USERNAME;
    const password = process.env.PASSWORD;
    
    // Check if credentials are available
    if (!username || !password) {
        console.error('Missing USERNAME or PASSWORD environment variables');
        throw new Error('Missing authentication credentials');
    }
    
    // Use Buffer.from instead of btoa for Node.js compatibility
    const credentials = Buffer.from(username + ':' + password).toString('base64');
    
    const headers = {
        'Authorization': 'Basic ' + credentials,
        'Content-Type': 'application/x-www-form-urlencoded'
    };
    
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: headers
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        console.log('Token received successfully');
        return data.access_token;
        
    } catch (error) {
        console.error('Error getting token:', error);
        throw error;
    }
}

// Function to perform AI query
async function doQuery(token, query, inputCsv) {
    const url = "https://api.ai.prod.us-east-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d85ed0c1b02d8a27/chat/completions?api-version=2023-05-15";
    const headers = {
        "Content-Type": "application/json",
        "AI-Resource-Group": "default",
        "Authorization": "Bearer " + token
    };
    
    const body = {
        "messages": [
            {
                "role": "user",
                "content": "Given following data in csv format:" + "\n \n" + inputCsv + "\n \n" + query
            }
        ],
        "max_tokens": 1000,
        "temperature": 0.0,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "stop": "null"
    };

    const requestOptions = {
        method: "POST",
        headers: headers,
        body: JSON.stringify(body)
    };

    return fetch(url, requestOptions)
    .then(response => response.json())
    .then(data => {
        return data;
    })
    .catch(error => console.log(error));
}

// Silent rating calculation function - no console output
function calculateOverallRating(windFarm) {
    const requiredFields = [
        'capacityFactorReal', 'windFarmEfficiency', 'windFarmRatedPowerMW', 
        'windFarmDensityMWKm2', 'rotorDiameterM', 'nacelleHeightM', 
        'windFarmAreaKm2', 'numberWT', 'wtRatedPowerMW'
    ];
    
    // Check if any required field is missing
    const hasAllFields = requiredFields.every(field => 
        windFarm[field] !== undefined && windFarm[field] !== null
    );
    
    if (!hasAllFields) {
        return { greenFields: 0, overallRating: 0.0 };
    }
    
    let greenFields = 0;
    
    if (windFarm.capacityFactorReal >= 45) greenFields++;
    if (windFarm.windFarmEfficiency >= 65) greenFields++;
    if (windFarm.windFarmRatedPowerMW > 200) greenFields++;
    if (windFarm.windFarmDensityMWKm2 > 7) greenFields++;
    if (windFarm.rotorDiameterM > 120) greenFields++;
    if (windFarm.nacelleHeightM > 120) greenFields++;
    if (windFarm.windFarmAreaKm2 > 50) greenFields++;
    if (windFarm.numberWT > 50) greenFields++;
    if (windFarm.wtRatedPowerMW >= 8) greenFields++;
    
    const overallRating = greenFields === 9 ? 5.0 : greenFields * 0.5;
    
    return { greenFields, overallRating };
}

module.exports = cds.service.impl(async function() {
    
    // Add computed overallRating after reading WindFarms
    this.after('READ', 'WindFarms', (results) => {
        if (Array.isArray(results)) {
            results.forEach(item => {
                // Only calculate if CDS rating doesn't exist or is 0
                if (!item.overallRating || item.overallRating === 0) {
                    const rating = calculateOverallRating(item);
                    item.overallRating = rating.overallRating;
                }
            });
        } else if (results) {
            // Only calculate if CDS rating doesn't exist or is 0
            if (!results.overallRating || results.overallRating === 0) {
                const rating = calculateOverallRating(results);
                results.overallRating = rating.overallRating;
            }
        }
    });

    // Event handler for checkAI action - Universal version
    this.onCheckAI = async function(req) {
        try {
            console.log('checkAI called with:', req.data);
            
            let windFarmData = [];
            let entityUsed = '';
            
            // Versuche verschiedene Entities in der Reihenfolge der Präferenz
            const entityPriority = [
                { name: 'WindFarms', ref: this.entities.WindFarms },
                { name: 'WindFarmAnalytics', ref: this.entities.WindFarmAnalytics },
                { name: 'WindFarmCorrelationAnalysis', ref: this.entities.WindFarmCorrelationAnalysis },
                { name: 'WindFarmRecommendations', ref: this.entities.WindFarmRecommendations}
            ];
            
            for (const entity of entityPriority) {
                if (entity.ref) {
                    try {
                        console.log(`Trying entity: ${entity.name}`);
                        windFarmData = await SELECT.from(entity.ref).columns([
                            'windFarm', 
                            'country', 
                            'capacityFactorReal', 
                            'windFarmEfficiency', 
                            'windFarmDensityMWKm2', 
                            'windFarmRatedPowerMW', 
                            'numberWT',
                            'rotorDiameterM',
                            'nacelleHeightM',
                            'windFarmAreaKm2',
                            'wtRatedPowerMW'

                        ]);
                        
                        if (windFarmData && windFarmData.length > 0) {
                            entityUsed = entity.name;
                            console.log(`Successfully loaded ${windFarmData.length} records from ${entity.name}`);
                            break;
                        }
                    } catch (entityError) {
                        console.log(`Entity ${entity.name} failed:`, entityError.message);
                        continue;
                    }
                }
            }
            
            if (windFarmData.length === 0) {
                return {
                    status: 'error',
                    message: 'No wind farm data found in any available entity',
                    availableEntities: entityPriority.map(e => e.name),
                    data: {}
                };
            }
            
            const headers = Object.keys(windFarmData[0]);
            let csv = headers.join(',') + '\n';

            windFarmData.forEach(obj => {
                const values = headers.map(header => obj[header] || ''); // Handle null values
                csv += values.join(',') + '\n';
            });
            
            console.log('Generated CSV:', csv);
            
            // Get the user input
            let userInput = req.data.Query;
            console.log('User input:', userInput);
            
            // Form query and send to AI endpoint
            try {
                // Get authentication token
                const bearerToken = await getToken();
                if (!bearerToken) {
                    throw new Error('Failed to get authentication token');
                }
                
                // Send query to AI endpoint
                const response = await doQuery(bearerToken, userInput, csv);
                console.log('AI Response:', response);
                
                // Display the AI response
                if (response && response.choices && response.choices[0] && response.choices[0].message) {
                    req.info(response.choices[0].message.content);
                    
                    console.log("Question: \n" + userInput);
                    console.log("Answer: \n" + response.choices[0].message.content);
                    
                    return {
                        status: 'success',
                        message: 'AI analysis completed',
                        timestamp: new Date().toISOString(),
                        userQuery: userInput,
                        aiAnswer: response.choices[0].message.content,
                        fullAiResponse: response,
                        entityUsed: entityUsed,
                        recordCount: windFarmData.length,
                        data: req.data || {}
                    };
                } else {
                    throw new Error('Invalid AI response format');
                }
                
            } catch (aiError) {
                console.error('Error in AI processing:', aiError);
                return {
                    status: 'error',
                    message: 'AI processing failed',
                    error: aiError.message,
                    csv: csv, // Return CSV for debugging
                    userQuery: userInput,
                    entityUsed: entityUsed
                };
            }
            
        } catch (error) {
            console.error('Error in onCheckAI:', error);
            return {
                status: 'error',
                message: 'AI check failed',
                error: error.message
            };
        }
    };
    
    // Register the checkAI event handler
    this.on("checkAI", (req) => this.onCheckAI(req));
    
});