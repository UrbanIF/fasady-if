# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

log = (a)-> console.log(a)

$ ->

  map = new GMaps
    div: '#map'
    lat: 48.9260402
    lng: 24.74123899999995
    zoom: 13
    markerClusterer: (map) ->
      new  MarkerClusterer(map)



  $(document).on 'click', '.object_name', ->
    lat = $(this).data('lat')
    lng = $(this).data('lng')
    map.setCenter(lat, lng)
    map.setZoom(18)




  setMarkers = (response)->
    for map_object in response
      map.addMarker
        lat: map_object.location[0]
        lng: map_object.location[1]
        title: map_object.name
        icon: "/assets/marker-#{map_object.color}.png"
        infoWindow:
          content: "<p>#{map_object.name}</p>"

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
      map.setCenter(datum.location[0], datum.location[1])
      map.setZoom(18)

  fillCategories = (response)->
    for category in response
      $('#categories').append "<div class='marker-desc'><div class='marker #{category.color}'></div><div class='desc'>#{category.name}</div></div>"

  $.ajax
    method: 'GET'
    url: '/api/map_objects/categories.json'
    success: (response)->
      fillCategories(response)

  $.ajax
    method: 'GET'
    url: '/api/map_objects.json'
    success: (response)->
      setMarkers(response)
      fillLeftPanelBuildingsList(response)
      initSearchField(response)




  $(document).on 'click', '.open-popup', ->
    $( '#' + $(this).data('id') ).addClass('active')

    map_add = new GMaps
      div: '#add_object_map'
      lat: 48.9260402
      lng: 24.74123899999995
      zoom: 13

    map_add.addMarker
      lat: 48.9260402
      lng: 24.74123899999995
      icon: '/assets/marker-add.png'


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
    $( '.popup_container' ).removeClass('active')

  $(document).on 'click', '#submit_object', ->
    $.ajax
      method: 'POST'
      url: '/api/map_objects.json'
      data:
        map_object:
          name:          'teststst'
          category_id:   '526ca064726f73ec73050000'
          location:     [48.917657,24.71507]
          address:
            prefix: 'вул.'
            street: 'Маланюка'
            building_number: 10
            modifier: ''

#          before_photos: [ {link: 'test' }]
#          after_photos:  [ {link: 'test' }]

      success: (response)->
        log response








