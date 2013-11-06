class Map
  constructor: (mapId, cluster = false)->
    @mapId = mapId
    @cluster = cluster
    @map = @initMap()
    @applyStyleToMap()

  initMap: ->
    new GMaps
      div: @mapId
      lat: 48.9260402
      lng: 24.74123899999995
      zoom: 13
      zoomControlOptions:
        style: google.maps.ZoomControlStyle.SMALL
        position: google.maps.ControlPosition.RIGHT_TOP
      panControlOptions:
        position: google.maps.ControlPosition.RIGHT_TOP
      scaleControlOptions:
        position: google.maps.ControlPosition.RIGHT_BOTTOM
      markerClusterer: (map) ->
        new  MarkerClusterer(map) if @cluster

  applyStyleToMap: ->
    @map.addStyle
      styledMapName:
        name: "Lighter"
      mapTypeId: "lighter"
      styles: [
        elementType: "geometry"
        stylers: [
          saturation: -90
          color: "#e3e2e1"
          lightness: 0
          weight: 0.5
        ]
      ,
        featureType: 'road.highway',
        elementType: 'geometry',
        stylers: [
          color: '#c1bba5'
        ]
      ,
        elementType: "labels"
        stylers: [visibility: "on"]
      ,
        featureType: "water"
        stylers: [color: "#cbd2da"]
      ]
    @map.setStyle 'lighter'

window.Map = Map