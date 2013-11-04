# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

log = (a)-> console.log(a)

$ ->

  window.App = {}

  initMap = ()->
    window.App.map = new GMaps
      div: '#map'
      lat: 48.9260402
      lng: 24.74123899999995
      zoom: 13
#      zoomControl: false
#      disableDefaultUI: true


      zoomControlOptions:
        style: google.maps.ZoomControlStyle.SMALL
        position: google.maps.ControlPosition.RIGHT_TOP
      panControlOptions:
        position: google.maps.ControlPosition.RIGHT_TOP
      scaleControlOptions:
        position: google.maps.ControlPosition.RIGHT_BOTTOM


      markerClusterer: (map) ->
        new  MarkerClusterer(map)


    App.map.addStyle
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

    App.map.setStyle('lighter')


  initMap()





  $(document).on 'click', '.object_name', ->
    lat = $(this).data('lat')
    lng = $(this).data('lng')
    App.map.setCenter(lat, lng)
    App.map.setZoom(18)




  setMarkers = (response)->
    markers_data = []
    for map_object in response
      markers_data.push
        lat: map_object.location[0]
        lng: map_object.location[1]
        title: map_object.name
        icon: "/assets/marker-#{map_object.color}.png"
        infoWindow:
          content: "<p>#{map_object.name}</p>"
        click: ()->
          log 'click'
#        mouseover:
#        mouseout:
    App.map.addMarkers(markers_data)


  fillLeftPanelBuildingsList = (response)->

    arrToHash = (orig) ->
      newObj = {}
      i = 0
      j = orig.length

      while i < j
        cur = orig[i]

        if newObj[cur.letter] == undefined
          newObj[cur.letter] = [cur]
        else
          newObj[cur.letter].push cur
        i++
      newObj

    hash = arrToHash(response)

    for letter, buildings of hash
      lis = ''
      for b in buildings
        lis += "<li data-lat='#{b.location[0]}' data-lng='#{b.location[1]}' class='object_name'>#{ b.address.street }, #{ b.address.building_number }</li>"
      $('#letters_list').append "<li class='objects_block'><div class='letter'>#{letter}</div><ul class='letter_objects'>#{lis}</ul></li>"


  initSearchField = (response)->
    $('#search').typeahead
      name: 'streets'
      local: response
      limit: 10

    $('#search').on 'typeahead:selected typeahead:autocompleted', (e, datum)->
      App.map.setCenter(datum.location[0], datum.location[1])
      App.map.setZoom(18)

  fillCategories = (response)->
    for category in response
      $('#categories').append "<div class='marker-desc'><div class='marker #{category.color}'></div><div class='desc'>#{category.name}</div></div>"

      $('#category_select').append "<option value='#{category.id}'>#{category.name}</option>"

  $.ajax
    method: 'GET'
    url: '/api/map_objects/categories.json'
    success: (response)->
      App.categories = response
      fillCategories(response)

  $.ajax
    method: 'GET'
    url: '/api/map_objects.json'
    success: (response)->
      App.mapObjects = response
      setMarkers(response)
      fillLeftPanelBuildingsList(response)
      initSearchField(response)




  $(document).on 'click', '#add_object', ->

    $('#category_select').dropkick()
    $('#add_object_popup').addClass('active')

    window.App.map_add = new GMaps
      div: '#add_object_map'
      lat: 48.9260402
      lng: 24.74123899999995
      zoom: 13
      zoomControlOptions:
        style: google.maps.ZoomControlStyle.SMALL
        position: google.maps.ControlPosition.RIGHT_TOP
      panControlOptions:
        position: google.maps.ControlPosition.RIGHT_TOP
      streetViewControl: false
      scaleControlOptions:
        position: google.maps.ControlPosition.RIGHT_BOTTOM


    App.map_add.addStyle
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

    App.map_add.setStyle('lighter')


    App.map_add.addMarker
      lat: 48.9260402
      lng: 24.74123899999995
      icon: '/assets/marker-add.png'
      draggable: true



    GMaps.on "click", App.map_add.map, (event) ->

      App.map_add.removeMarkers()
      lat = event.latLng.lat()
      lng = event.latLng.lng()

      App.map_add.addMarker
        lat: lat
        lng: lng
        icon: '/assets/marker-add.png'
        draggable: true



  #    GMaps.geocode
#
#      address: $("#popup_search").val()
#
#      callback: (results, status) ->
#        if status is "OK"
#          latlng = results[0].geometry.location
#          map_add.setCenter latlng.lat(), latlng.lng()
#          map_add.addMarker
#            lat: latlng.lat()
#            lng: latlng.lng()
#        else
#          log 'error'



  $(document).on 'click', '.popup_bg', ->
    $(this).parents( '.popup_container' ).removeClass('active')

  $(document).on 'click', '#about_toggle', ->
    $('#about').toggleClass('active')



  $(document).on 'click', '#submit_object', ->
    $.ajax
      method: 'POST'
      url: '/api/map_objects.json'
      data:
        map_object:
          name:          $('#map_object_name').val()
          category_id:   $('#category_select').val()
          location:      [ App.map_add.markers[0].position.lb, App.map_add.markers[0].position.mb ]
          address:
            prefix: 'вул.'
            street: 'Маланюка'
            building_number: 10
            modifier: ''

#          before_photos: [ {link: 'test' }]
#          after_photos:  [ {link: 'test' }]

    .done ()->
      $('#add_object_popup').removeClass('active')
      $('#addition_success-popup').addClass('active')
    .fail()




  filterObjectsByCategory = (categoryName)->
    objectsFiltered = (object for object in App.mapObjects when object.category == categoryName)
    App.map.removeMarkers()
    App.map.markerClusterer.clearMarkers()
    setMarkers(objectsFiltered)


  $(document).on 'click', '.marker-desc', ->
    categoryName = $(this).find('.desc').html()
    filterObjectsByCategory(categoryName)






