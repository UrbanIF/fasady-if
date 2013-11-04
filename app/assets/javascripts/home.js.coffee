# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

log = (a)-> console.log(a)

$ ->

  class Fasady
    mainMap: null
    popupMap: null
    map_object_json: null
    categories_json: null


    constructor: ->
      @mainMap = @_getInitedMap('#map')
      @_applyStyleToMap(@mainMap)

      @_clicksHandling()

      $.ajax
        method: 'GET'
        url: '/api/map_objects/categories.json'
        success: (response)=>
          @categories_json = response

          @fillCategories()

      $.ajax
        method: 'GET'
        url: '/api/map_objects.json'
        success: (response)=>
          @map_object_json = response

          @createMapMarkersOnMainMap(@map_object_json)
          @fillLeftPanelBuildingsList()
          @initSearchField()


    _clicksHandling: ->
      self = @
      # ABOUT PAGE
      $(document).on 'click', '#about_toggle', ->
        $('#about').toggleClass('active')

      # HIDE POPUP
      $(document).on 'click', '.popup_bg', ->
        $(this).parents( '.popup_container' ).removeClass('active')

      # GO TO MARKER IF CLICK ON LEFT PANEL
      $(document).on 'click', '.object_name', ->
        lat = $(this).data('lat')
        lng = $(this).data('lng')
        self.mainMap.setCenter(lat, lng)
        self.mainMap.setZoom(18)

      $(document).on 'click', '.marker-desc', ->
        categoryName = $(this).find('.desc').html()
        self._filterObjectsByCategory(categoryName)



      $(document).on 'click', '#add_object', =>

        $('#add_object_popup').addClass('active')

        $('#category_select').dropkick()

        @popupMap = @_getInitedMap('#add_object_map')
        @_applyStyleToMap(@popupMap)
        @popupMap.addMarker
          lat: 48.9260402
          lng: 24.74123899999995
          icon: '/assets/marker-add.png'
          draggable: true


        GMaps.on "click", @popupMap.map, (event) =>
          @popupMap.removeMarkers()
          @popupMap.addMarker
            lat: event.latLng.lat()
            lng: event.latLng.lng()
            icon: '/assets/marker-add.png'
            draggable: true



      $(document).on 'click', '#submit_object', =>
        $.ajax
          method: 'POST'
          url: '/api/map_objects.json'
          data:
            map_object:
              name:          $('#map_object_name').val()
              category_id:   $('#category_select').val()
              location:      [ @popupMap.markers[0].position.lb, @popupMap.markers[0].position.mb ]
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



    createMapMarkersOnMainMap: (map_objects)->
      markers = []
      for map_object in map_objects
        markers.push
          lat: map_object.location[0]
          lng: map_object.location[1]
          title: map_object.name
          icon: "/assets/marker-#{map_object.color}.png"
          infoWindow:
            content: "<p>#{map_object.name}</p>"
          click: ()->
            log 'click'
      @mainMap.addMarkers(markers)



    fillCategories: ->
      for category in @categories_json
        $('#categories').append "<div class='marker-desc'><div class='marker #{category.color}'></div><div class='desc'>#{category.name}</div></div>"
        $('#category_select').append "<option value='#{category.id}'>#{category.name}</option>"

    fillLeftPanelBuildingsList: ->
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

      hash = arrToHash(@map_object_json)

      for letter, buildings of hash
        lis = ''
        for b in buildings
          lis += "<li data-lat='#{b.location[0]}' data-lng='#{b.location[1]}' class='object_name'>#{ b.address.street }, #{ b.address.building_number }</li>"
        $('#letters_list').append "<li class='objects_block'><div class='letter'>#{letter}</div><ul class='letter_objects'>#{lis}</ul></li>"


    _filterObjectsByCategory: (categoryName) =>
      objectsFiltered = (object for object in @map_object_json when object.category == categoryName)
      log objectsFiltered
      @mainMap.removeMarkers()
      @mainMap.markerClusterer.clearMarkers()
      @createMapMarkersOnMainMap(objectsFiltered)




    initSearchField: ->
      $('#search').typeahead
        name: 'streets'
        local: @map_object_json
        limit: 10

      $('#search').on 'typeahead:selected typeahead:autocompleted', (e, datum)=>
        @mainMap.setCenter(datum.location[0], datum.location[1])
        @mainMap.setZoom(18)




    _getInitedMap: (map_id)->
      new GMaps
        div: map_id
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

    _applyStyleToMap: (map)->
      map.addStyle
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

      map.setStyle('lighter')




  new Fasady()
