# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  map = new GMaps
    div: '#map'
    lat: -12.043333
    lng: -77.028333


  map.addMarker
    lat: -12.043333
    lng: -77.028333
    title: 'Lima'
    infoWindow:
      content: '<p>HTML Content</p>'
#    click: (e)->
#      alert('You clicked in this marker')



  map.addMarker
    lat: -12.043333
    lng: -77.028433
    title: 'Second'
    infoWindow:
      content: '<p>HTML Content</p>'