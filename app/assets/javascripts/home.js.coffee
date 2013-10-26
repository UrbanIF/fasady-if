# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

log = (a)-> console.log(a)
$ ->
  map = new GMaps
    div: '#map'
    lat: -12.043333
    lng: -77.028333


  $.ajax
    method: 'GET'
    url: '/api/map_objects/categories.json'
    success: (response)->
      for category in response
        log category.name

  $.ajax
    method: 'GET'
    url: '/api/map_objects.json'
    success: (response)->
      for map_object in response
        map.addMarker
          lat: map_object.location[0]
          lng: map_object.location[1]
          title: map_object.name
          infoWindow:
            content: "<p>#{map_object.name}</p>"


#  map.addMarker
#    lat: -12.043333
#    lng: -77.028333
#    title: 'Lima'
#    infoWindow:
#      content: '<p>HTML Content</p>'
##    click: (e)->
##      alert('You clicked in this marker')
#
#  map.addMarker
#    lat: -12.043333
#    lng: -77.028433
#    title: 'Second'
#    infoWindow:
#      content: '<p>HTML Content</p>'

#
#  map.addMapType(
#    "osm",
#    {
#      getTileUrl: (coord, zoom)->
#        "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png";
#    },
#    tileSize: new google.maps.Size(256, 256),
#    name: "OpenStreetMap",
#    maxZoom: 18
#  )


  $('#search').typeahead
    name: 'streets'
    local: ['Маланюка', 'Махалюка', 'МахаСивака']
    limit: 10

#    prefetch: 'https://twitter.com/network.json'
#    remote: 'https://twitter.com/accounts?q=%QUERY'



  $('#search').on 'typeahead:selected typeahead:autocompleted', (e)->
    log e