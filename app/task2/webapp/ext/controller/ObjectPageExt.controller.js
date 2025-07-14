sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/MessageToast"
], function (ControllerExtension, MessageToast) {
    "use strict";

    return ControllerExtension.extend("ns.task2.ext.controller.ObjectPageExt", {
        
        override: {
            onInit: function () {
                console.log("🗺️ MAP: Extension loaded - Button Mode");
                
                // Cleanup existing buttons first
                this._cleanupMapButton();
                
                setTimeout(() => {
                    this._addMapButton();
                }, 2000);
            },
            
            onExit: function() {
                console.log("🗺️ MAP: Extension exiting - cleaning up");
                // Force cleanup when extension really exits
                this._forceCleanup();
            }
        },

        _forceCleanup: function() {
            // This is only called when extension really exits
            const existingButton = document.querySelector('.wind-farm-map-button');
            const existingModal = document.querySelector('.wind-farm-map-modal');
            
            if (existingButton) {
                existingButton.remove();
                console.log("🗺️ MAP: Force removed button");
            }
            
            if (existingModal) {
                existingModal.remove();
                console.log("🗺️ MAP: Force removed modal");
            }
            
            if (this._routeChangeListener) {
                window.removeEventListener('hashchange', this._routeChangeListener);
                this._routeChangeListener = null;
            }
        },

        _cleanupMapButton: function() {
            // Remove existing modal (always safe to remove)
            const existingModal = document.querySelector('.wind-farm-map-modal');
            if (existingModal) {
                existingModal.remove();
                console.log("🗺️ MAP: Removed existing modal");
            }
            
            // Only remove button if we're really leaving the page
            const currentHash = window.location.hash;
            const shouldRemoveButton = !currentHash.includes('WindFarms(') && !currentHash.includes('/WindFarms');
            
            if (shouldRemoveButton) {
                const existingButton = document.querySelector('.wind-farm-map-button');
                if (existingButton) {
                    existingButton.remove();
                    console.log("🗺️ MAP: Removed button (left WindFarms page)");
                }
                
                // Remove route listener if exists
                if (this._routeChangeListener) {
                    window.removeEventListener('hashchange', this._routeChangeListener);
                    this._routeChangeListener = null;
                }
            } else {
                console.log("🗺️ MAP: Keeping button (still on WindFarms page)");
            }
        },

        _addMapButton: function() {
            console.log("🗺️ MAP: Adding map button...");
            
            // DON'T cleanup existing button - keep it if it exists!
            
            let attempts = 0;
            const maxAttempts = 15;
            
            const tryAddButton = () => {
                attempts++;
                console.log(`🗺️ MAP: Button attempt ${attempts}/${maxAttempts}`);
                
                if (this._createMapButton() || attempts >= maxAttempts) {
                    console.log("🗺️ MAP: Button attempts finished");
                    return;
                }
                
                setTimeout(tryAddButton, 1500);
            };
            
            tryAddButton();
        },

        _createMapButton: function() {
            try {
                // Check if button already exists - if yes, keep it
                if (document.querySelector('.wind-farm-map-button')) {
                    console.log("🗺️ MAP: Button already exists, keeping it");
                    return true;
                }

                // Get data
                const oView = this.getView();
                if (!oView) return false;
                
                const oContext = oView.getBindingContext();
                if (!oContext) return false;
                
                const oData = oContext.getObject();
                if (!oData || !oData.latitude || !oData.longitude) return false;

                console.log("🗺️ MAP: Creating map button for:", oData.windFarm);

                // Find a good location for the button (try multiple selectors)
                const containers = [
                    document.querySelector('.sapUxAPObjectPageHeaderContent'),
                    document.querySelector('.sapUxAPObjectPageSection'),
                    document.querySelector('.sapMPanel'),
                    document.querySelector('.sapUxAPObjectPageContainer')
                ].filter(Boolean);

                if (containers.length === 0) {
                    console.log("🗺️ MAP: No suitable container found");
                    return false;
                }

                const targetContainer = containers[0];

                // Create map button - dauerhaft unten rechts
                const mapButton = document.createElement('button');
                mapButton.className = 'wind-farm-map-button';
                mapButton.innerHTML = '🗺️ Show Location & Weather';
                mapButton.style.cssText = `
                    position: fixed;
                    bottom: 20px;
                    right: 20px;
                    background: linear-gradient(135deg, #0070f3 0%, #0056b3 100%);
                    color: white;
                    border: none;
                    padding: 12px 20px;
                    border-radius: 25px;
                    cursor: pointer;
                    font-size: 14px;
                    font-weight: 600;
                    box-shadow: 0 4px 15px rgba(0,112,243,0.3);
                    z-index: 1000;
                    transition: all 0.3s ease;
                    white-space: nowrap;
                `;

                // Hover effects
                mapButton.onmouseover = () => {
                    mapButton.style.transform = 'translateY(-5px) scale(1.05)';
                    mapButton.style.boxShadow = '0 6px 20px rgba(0,112,243,0.4)';
                };
                mapButton.onmouseout = () => {
                    mapButton.style.transform = 'translateY(0)';
                    mapButton.style.boxShadow = '0 4px 15px rgba(0,112,243,0.3)';
                };

                // Click handler to open map modal
                mapButton.onclick = () => {
                    this._openMapModal(oData);
                };

                // Add to page with cleanup on route change
                document.body.appendChild(mapButton);

                // Listen for route changes to cleanup button
                this._setupRouteChangeListener();

                console.log("🗺️ MAP: Map button created successfully!");
                
                return true;

            } catch (error) {
                console.error("🗺️ MAP: Error creating button:", error);
                return false;
            }
        },

        _setupRouteChangeListener: function() {
            // Listen for hash changes (route changes)
            const handleRouteChange = () => {
                console.log("🗺️ MAP: Route changed, checking if still on WindFarms page");
                
                // Check if we're still on a WindFarms detail page
                const currentHash = window.location.hash;
                console.log("🗺️ MAP: Current hash:", currentHash);
                
                // Only cleanup if we're NOT on a WindFarms detail page
                if (!currentHash.includes('WindFarms(') && !currentHash.includes('/WindFarms')) {
                    console.log("🗺️ MAP: Left WindFarms page, cleaning up button");
                    this._cleanupMapButton();
                    
                    // Remove listener
                    window.removeEventListener('hashchange', handleRouteChange);
                } else {
                    console.log("🗺️ MAP: Still on WindFarms page, keeping button");
                }
            };
            
            // Store listener reference for cleanup
            this._routeChangeListener = handleRouteChange;
            window.addEventListener('hashchange', handleRouteChange);
        },

        _openMapModal: function(oData) {
            console.log("🗺️ MAP: Opening map modal for:", oData.windFarm);

            // Remove existing modal if any (but NOT the button!)
            const existingModal = document.querySelector('.wind-farm-map-modal');
            if (existingModal) {
                existingModal.remove();
            }

            const lat = parseFloat(oData.latitude);
            const lng = parseFloat(oData.longitude);

            // Create modal overlay
            const modalOverlay = document.createElement('div');
            modalOverlay.className = 'wind-farm-map-modal';
            modalOverlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 10000;
                display: flex;
                align-items: center;
                justify-content: center;
                animation: fadeIn 0.3s ease;
            `;

            // Create modal content
            const modalContent = document.createElement('div');
            modalContent.style.cssText = `
                background: white;
                border-radius: 12px;
                width: 90%;
                max-width: 500px;
                max-height: 90%;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                animation: slideIn 0.3s ease;
            `;

            // Modal header mit zentriertem Pin und Name
            const modalHeader = document.createElement('div');
            modalHeader.style.cssText = `
                background: linear-gradient(135deg, #0070f3 0%, #0056b3 100%);
                color: white;
                padding: 15px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: relative;
            `;

            const modalTitle = document.createElement('div');
            modalTitle.innerHTML = `📍 ${oData.windFarm}`;
            modalTitle.style.cssText = `
                position: absolute;
                left: 50%;
                transform: translateX(-50%);
                margin: 0;
                font-size: 18px;
                font-weight: 600;
                text-align: center;
            `;

            // Spacer for layout
            const spacer = document.createElement('div');
            spacer.style.width = '30px';

            const closeButton = document.createElement('button');
            closeButton.innerHTML = '×';
            closeButton.style.cssText = `
                background: none;
                border: none;
                color: white;
                font-size: 24px;
                cursor: pointer;
                padding: 0;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                transition: background 0.2s;
            `;
            closeButton.onmouseover = () => closeButton.style.background = 'rgba(255,255,255,0.2)';
            closeButton.onmouseout = () => closeButton.style.background = 'none';

            modalHeader.appendChild(spacer);
            modalHeader.appendChild(modalTitle);
            modalHeader.appendChild(closeButton);

            // Modal body
            const modalBody = document.createElement('div');
            modalBody.style.cssText = `
                padding: 20px;
            `;

            // Coordinates display - genau wie im Screenshot
            const coordsDisplay = document.createElement('div');
            coordsDisplay.innerHTML = `
                <div style="background: #f8f9fa; padding: 12px; border-radius: 6px; margin-bottom: 15px; text-align: center;">
                    <div style="font-size: 16px; font-weight: 600; color: #333; margin-bottom: 5px;">
                        📍 Coordinates: ${lat.toFixed(4)}, ${lng.toFixed(4)}
                    </div>
                    <div style="font-size: 14px; color: #666;">
                        🌊 ${oData.sea || 'Baltic Sea'} • 🏭 ${oData.locationCountry || 'Germany'}
                    </div>
                </div>
            `;

            // Map container
            const mapContainer = document.createElement('div');
            mapContainer.style.cssText = `
                margin-bottom: 15px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                overflow: hidden;
            `;

            // OpenStreetMap iframe
            const mapFrame = document.createElement('iframe');
            const bbox = `${lng-0.05},${lat-0.05},${lng+0.05},${lat+0.05}`;
            mapFrame.src = `https://www.openstreetmap.org/export/embed.html?bbox=${bbox}&layer=mapnik&marker=${lat},${lng}`;
            mapFrame.style.cssText = `
                width: 100%;
                height: 250px;
                border: none;
            `;

            mapContainer.appendChild(mapFrame);

            // Action buttons container
            const buttonsContainer = document.createElement('div');
            buttonsContainer.style.cssText = `
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            `;

            // Create action buttons with weather integration
            const createActionButton = (text, icon, color, action, style = {}) => {
                const btn = document.createElement('button');
                btn.innerHTML = `${icon} ${text}`;
                btn.style.cssText = `
                    flex: 1;
                    min-width: 100px;
                    padding: 10px 12px;
                    border: none;
                    background: ${color};
                    color: white;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 13px;
                    font-weight: 600;
                    transition: all 0.2s;
                    text-align: center;
                    ${Object.entries(style).map(([k, v]) => `${k}: ${v}`).join('; ')};
                `;
                btn.onmouseover = () => {
                    btn.style.transform = 'translateY(-2px)';
                    btn.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
                };
                btn.onmouseout = () => {
                    btn.style.transform = 'translateY(0)';
                    btn.style.boxShadow = 'none';
                };
                btn.onclick = action;
                return btn;
            };

            // Google Maps button
            const googleBtn = createActionButton('Google Maps', '🗺️', '#4285f4', () => {
                window.open(`https://www.google.com/maps?q=${lat},${lng}&z=12`, '_blank');
                MessageToast.show("Opening Google Maps...");
            });

            // OpenStreetMap button - zentrierter Text
            const osmBtn = createActionButton('OpenStreetMap', '🌍', '#7ebc6f', () => {
                window.open(`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=12/${lat}/${lng}`, '_blank');
                MessageToast.show("Opening OpenStreetMap...");
            }, { 'text-align': 'center' });

            // Copy coordinates button
            const copyBtn = createActionButton('Copy Coords', '📋', '#6c757d', () => {
                const coords = `${lat}, ${lng}`;
                navigator.clipboard.writeText(coords).then(() => {
                    MessageToast.show("📋 Coordinates copied!");
                }).catch(() => {
                    MessageToast.show(`📋 Coordinates: ${coords}`);
                });
            });

            // Weather button - mit besserer Wetter-Integration
            const weatherBtn = createActionButton('Weather', '🌤️', '#ff9800', () => {
                // Versuche verschiedene Wetter-Services für bessere Kompatibilität
                const weatherUrls = [
                    `https://www.windy.com/${lat.toFixed(3)}/${lng.toFixed(3)}?${lat.toFixed(3)},${lng.toFixed(3)},11`,
                    `https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature&lat=${lat}&lon=${lng}&zoom=10`,
                    `https://weather.com/weather/today/l/${lat.toFixed(4)},${lng.toFixed(4)}`
                ];
                
                // Verwende Windy.com - funktioniert am besten mit Koordinaten
                window.open(weatherUrls[0], '_blank');
                MessageToast.show(`🌤️ Opening weather for coordinates ${lat.toFixed(3)}, ${lng.toFixed(3)}`);
            }, { 'text-align': 'center' });

            // Close map button
            const closeMapBtn = createActionButton('Close Map', '❌', '#dc3545', () => {
                modalOverlay.remove();
                // DON'T cleanup the button when closing modal!
            }, { 'width': '100%', 'margin-top': '10px' });

            // Assemble buttons
            buttonsContainer.appendChild(googleBtn);
            buttonsContainer.appendChild(osmBtn);
            buttonsContainer.appendChild(copyBtn);
            buttonsContainer.appendChild(weatherBtn);

            // Assemble modal
            modalBody.appendChild(coordsDisplay);
            modalBody.appendChild(mapContainer);
            modalBody.appendChild(buttonsContainer);
            modalBody.appendChild(closeMapBtn);

            modalContent.appendChild(modalHeader);
            modalContent.appendChild(modalBody);
            modalOverlay.appendChild(modalContent);

            // Event handlers - NUR Modal schließen, nicht Button entfernen
            closeButton.onclick = () => modalOverlay.remove();
            modalOverlay.onclick = (e) => {
                if (e.target === modalOverlay) {
                    modalOverlay.remove();
                }
            };

            // Escape key handler - NUR Modal schließen
            const escapeHandler = (e) => {
                if (e.key === 'Escape') {
                    modalOverlay.remove();
                    document.removeEventListener('keydown', escapeHandler);
                }
            };
            document.addEventListener('keydown', escapeHandler);

            // Add CSS animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                @keyframes slideIn {
                    from { transform: scale(0.8) translateY(-20px); opacity: 0; }
                    to { transform: scale(1) translateY(0); opacity: 1; }
                }
            `;
            document.head.appendChild(style);

            // Add to page
            document.body.appendChild(modalOverlay);

            console.log("🗺️ MAP: Modal opened successfully!");
        }
    });
});