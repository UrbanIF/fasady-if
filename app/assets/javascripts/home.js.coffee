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



  $.ajax
    method: 'GET'
    url: '/api/map_objects/categories.json'
    success: (response)->
      for category in response
        log category.name


  setMarkers = (response)->
    for map_object in response
      map.addMarker
        lat: map_object.location[0]
        lng: map_object.location[1]
        title: map_object.name
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
        lis += "<li class='object_name' >#{ b.address.street }, #{ b.address.building_number }</li>"
      $('#letters_list').append "<li class='objects_block'><div class='letter'>#{letter}</div><ul class='letter_objects'>#{lis}</ul></li>"


  initSearchField = (response)->
    $('#search').typeahead
      name: 'streets'
      local: response
      limit: 10

    $('#search').on 'typeahead:selected typeahead:autocompleted', (e)->
      log e


  $.ajax
    method: 'GET'
    url: '/api/map_objects.json'
    success: (response)->
      setMarkers(response)
      fillLeftPanelBuildingsList(response)
      initSearchField(response)


