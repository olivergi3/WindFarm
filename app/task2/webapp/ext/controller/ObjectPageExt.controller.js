sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/MessageToast"
], function (ControllerExtension, MessageToast) {
    "use strict";

    return ControllerExtension.extend("ns.task2.ext.controller.ObjectPageExt", {
        
        override: {
            onInit: function () {
                console.log("🔧 DEBUG: Controller Extension initialized");
                
                
                let attempts = 0;
                const maxAttempts = 10;
                
                const tryAddMap = () => {
                    attempts++;
                    console.log(`🔧 DEBUG: Attempt ${attempts}/${maxAttempts} to add map`);
                    
                    if (this._addMapToLocationSection() || attempts >= maxAttempts) {
                        console.log("🔧 DEBUG: Stopping attempts");
                        return;
                    }
                    
                    setTimeout(tryAddMap, 1000);
                };
                
                setTimeout(tryAddMap, 1000);
            }
        },

        _addMapToLocationSection: function() {
            console.log("🔧 DEBUG: _addMapToLocationSection called");
            
            const oView = this.getView();
            console.log("🔧 DEBUG: View:", oView);
            
            const oBindingContext = oView.getBindingContext();
            console.log("🔧 DEBUG: Binding Context:", oBindingContext);
            
            if (!oBindingContext) {
                console.log("🔧 DEBUG: No binding context available");
                return false;
            }

            const oWindFarm = oBindingContext.getObject();
            console.log("🔧 DEBUG: Wind farm data:", oWindFarm);

            if (!oWindFarm || !oWindFarm.latitude || !oWindFarm.longitude) {
                console.log("🔧 DEBUG: No coordinates available");
                return false;
            }

            
            console.log("🔧 DEBUG: Searching for location section...");
            this._debugPageStructure();

            
            return this._injectMapIntoLocationSection(oWindFarm);
        },

        _debugPageStructure: function() {
            
            const allElements = document.querySelectorAll('*');
            console.log("🔧 DEBUG: Total elements on page:", allElements.length);
            
            
            const panels = document.querySelectorAll('[role="region"], .sapUxAPObjectPageSection, .sapMPanel');
            console.log("🔧 DEBUG: Found panels:", panels.length);
            
            panels.forEach((panel, index) => {
                const text = panel.textContent?.substring(0, 100) || '';
                console.log(`🔧 DEBUG: Panel ${index}:`, text);
            });
        },

        _injectMapIntoLocationSection: function(oWindFarm) {
            console.log("🔧 DEBUG: _injectMapIntoLocationSection called");
            
        
            const selectors = [
                '[role="region"]',
                '.sapUxAPObjectPageSection',
                '.sapMPanel',
                '[data-sap-ui*="LocationMapFacet"]',
                '.sapUiForm'
            ];

            let locationContainer = null;

            for (let selector of selectors) {
                const elements = document.querySelectorAll(selector);
                console.log(`🔧 DEBUG: Found ${elements.length} elements for selector: ${selector}`);
                
                for (let element of elements) {
                    const text = element.textContent || '';
                    if (text.includes('Location') || text.includes('Map') || text.includes('Latitude')) {
                        console.log("🔧 DEBUG: Found potential location container:", element);
                        locationContainer = element;
                        break;
                    }
                }
                
                if (locationContainer) break;
            }

            if (!locationContainer) {
                console.log("🔧 DEBUG: No location container found, trying to add to any available container");
                
                const sections = document.querySelectorAll('.sapUxAPObjectPageSection');
                if (sections.length > 1) {
                    locationContainer = sections[1]; 
                    console.log("🔧 DEBUG: Using fallback container:", locationContainer);
                }
            }

            if (locationContainer && !locationContainer.querySelector('.custom-map-container')) {
                console.log("🔧 DEBUG: Adding map to container");
                this._createMapHTML(locationContainer, oWindFarm);
                return true;
            } else {
                console.log("🔧 DEBUG: Container not found or map already exists");
                return false;
            }
        },

        _createMapHTML: function(container, oWindFarm) {
            console.log("🔧 DEBUG: Creating map HTML for:", oWindFarm.windFarm);
            
            // Erstelle Map Container
            const mapContainer = document.createElement('div');
            mapContainer.className = 'custom-map-container';
            mapContainer.style.cssText = `
                margin: 20px 0;
                padding: 20px;
                border: 2px solid #0070f3;
                border-radius: 8px;
                background-color: #f8faff;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            `;

            // Map Title
            const mapTitle = document.createElement('h3');
            mapTitle.textContent = `🗺️ ${oWindFarm.windFarm} Location`;
            mapTitle.style.cssText = `
                margin: 0 0 16px 0;
                color: #0070f3;
                font-size: 18px;
                font-weight: 600;
                text-align: center;
            `;

            // Map iframe
            const lat = parseFloat(oWindFarm.latitude);
            const lng = parseFloat(oWindFarm.longitude);
            const bbox = `${lng-0.8},${lat-0.8},${lng+0.8},${lat+0.8}`;
            const mapUrl = `https://www.openstreetmap.org/export/embed.html?bbox=${bbox}&layer=mapnik&marker=${lat},${lng}`;
            
            console.log("🔧 DEBUG: Map URL:", mapUrl);
            
            const mapIframe = document.createElement('iframe');
            mapIframe.src = mapUrl;
            mapIframe.style.cssText = `
                width: 100%;
                height: 400px;
                border: 1px solid #ddd;
                border-radius: 6px;
                margin-bottom: 16px;
            `;

            // Info Panel
            const infoPanel = document.createElement('div');
            infoPanel.style.cssText = `
                background: white;
                padding: 12px;
                border-radius: 6px;
                border: 1px solid #e5e5e5;
            `;

            const coordText = document.createElement('div');
            coordText.innerHTML = `
                <strong>📍 Coordinates:</strong> ${lat}, ${lng}<br>
                <strong>🌊 Location:</strong> ${oWindFarm.description || 'Offshore wind farm'}<br>
                <strong>🏭 Operator:</strong> ${oWindFarm.description?.match(/operated by ([^in]+)/)?.[1] || 'Unknown'}
            `;
            coordText.style.cssText = `
                font-size: 14px;
                line-height: 1.4;
                margin-bottom: 12px;
            `;

            // Action Buttons
            const buttonContainer = document.createElement('div');
            buttonContainer.style.cssText = `
                display: flex;
                gap: 8px;
                justify-content: center;
            `;

            // Create buttons
            const createButton = (text, color, action) => {
                const btn = document.createElement('button');
                btn.textContent = text;
                btn.style.cssText = `
                    padding: 8px 16px;
                    border: 1px solid ${color};
                    background: ${color};
                    color: white;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 14px;
                    font-weight: 500;
                `;
                btn.onclick = action;
                return btn;
            };

            const googleBtn = createButton('🗺️ Google Maps', '#4285f4', () => {
                window.open(`https://www.google.com/maps?q=${lat},${lng}&z=12`, '_blank');
                MessageToast.show("Opening in Google Maps...");
            });

            const osmBtn = createButton('🌍 OpenStreetMap', '#7ebc6f', () => {
                window.open(`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=12/${lat}/${lng}`, '_blank');
                MessageToast.show("Opening in OpenStreetMap...");
            });

            const copyBtn = createButton('📋 Copy Coordinates', '#666', () => {
                navigator.clipboard.writeText(`${lat}, ${lng}`).then(() => {
                    MessageToast.show("Coordinates copied to clipboard!");
                }).catch(() => {
                    MessageToast.show(`Coordinates: ${lat}, ${lng}`);
                });
            });

            // Zusammenbauen
            buttonContainer.appendChild(googleBtn);
            buttonContainer.appendChild(osmBtn);
            buttonContainer.appendChild(copyBtn);
            
            infoPanel.appendChild(coordText);
            infoPanel.appendChild(buttonContainer);

            mapContainer.appendChild(mapTitle);
            mapContainer.appendChild(mapIframe);
            mapContainer.appendChild(infoPanel);

            // Map zum Container hinzufügen
            container.appendChild(mapContainer);

            console.log("🔧 DEBUG: Map successfully added to container!");
        }
    });
});