# todo додати можливіть коментувати об’єкти
$ ->
  class Fasady
    mainMap: null
    popupMap: null
    map_object_json: null
    categories_json: null

    interv: null

    constructor: ->
      @mainMap = (new window.Map('#map', true)).map

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
          @renderAllMapObjects()

      $(document).on 'show_object', @showObject

    renderAllMapObjects: ()=>
      @createMapMarkersOnMainMap(@map_object_json)
      @fillLeftPanelBuildingsList(@map_object_json)
      @initSearchField()

    showObject: (e, mapObject) =>
      @_fillMapObjectDescription mapObject
      clearInterval(@interv)
      @mainMap.setCenter mapObject.location[0], mapObject.location[1]
      @mainMap.setZoom 18

    _clicksHandling: ->
      self = @
      # ABOUT PAGE
      $(document).on 'click', '#about_toggle', ->
        $('#about').toggleClass('active')

      # HIDE POPUP
      $(document).on 'click', '.popup_bg, .popup_close', ->
        $(this).parents( '.popup_container' ).removeClass('active')

      # GO TO MARKER IF CLICK ON LEFT PANEL
      $(document).on 'click', '.object_name', ->
        $(document).trigger 'show_object', [$(@).data('mapObject')]

      $(document).on 'click', '.marker-desc', ->
        $this = $(@)
        if $this.hasClass('active')
          $('.marker-desc').removeClass('active').removeClass('disactive')
          categoryName = ''
        else
          $(".marker-desc").addClass('disactive').removeClass('active')
          $this.removeClass('disactive').addClass('active')
          categoryName = $this.children('.desc').html()

        self._filterObjectsByCategory(categoryName)


      $(document).on 'click', '#map_object_close', =>
        @_closeObjectDescription()

      $('#map-object_image-button').on 'click', ->
        $('.map-object_image').toggleClass('alfa-zero')
        $('#map-object_image-button').text if $('#map-object_image-button').text() == 'Фото існуючого стану'
          'Проектна пропозиція'
        else
          'Фото існуючого стану'

    createMapMarkersOnMainMap: (map_objects)->
      map = @mainMap.map
      for map_object in map_objects
        marker = new google.maps.Marker
          position: new google.maps.LatLng(map_object.location[0], map_object.location[1])
          title: map_object.name
          map: map
          icon: window.markers[map_object.color]

        @mainMap.markers.push marker

        infobox = new InfoBox
          content: "<img width='236' height='150' src='#{map_object.thumb}'><h3>#{map_object.name}</h3>"
          disableAutoPan: true
          maxWidth: 0
          alignBottom: true
          pixelOffset: new google.maps.Size(-118, -92)
          closeBoxURL: ""
          isHidden: false
          pane: "floatPane"
          enableEventPropagation: false

        ((map, marker, map_object, infowindow, self)->
          google.maps.event.addListener marker, 'mouseover', ->
            infowindow.open(map, @)

          google.maps.event.addListener marker, 'mouseout', ->
            infowindow.close()

          google.maps.event.addListener marker, 'click', ->
            self._fillMapObjectDescription(map_object)
            self._openObjectDescription(map_object.location[0], map_object.location[1])

        )(map, marker, map_object, infobox, @)


    _fillMapObjectDescription: (map_object)=>
      $('#map_object_title').text(map_object.name)
      $('#map_object_address').text "#{ map_object.address.prefix } #{ map_object.address.street }, #{ map_object.address.building_number }"
      $('#map_object_author_name').text map_object.user.name
      $('#map_object_author_avatar').prop('src', map_object.user.avatar) if map_object.user.avatar?
      $('#map-object_image-before').prop('src', map_object.before_photo)
      $('#map-object_image-after').prop('src', map_object.after_photo)

    _openObjectDescription: (lat, lng)=>
      $('.right_container').addClass('show-object')
      i = 0
      @interv = setInterval(
        =>
          @mainMap.refresh()
          @mainMap.setCenter(lat, lng)
          @mainMap.setZoom(18)
          i = i + 5
          if i > 600
            clearInterval(@interv)
        5
      )

    _closeObjectDescription: =>
      $('.right_container').removeClass('show-object')
      i = 0
      center = @mainMap.getCenter()
      @interv = setInterval(
        =>
          @mainMap.refresh()
          @mainMap.setCenter center.lat(), center.lng()
          i = i + 5
          if i > 600
            clearInterval(@interv)
        5
      )

    fillCategories: ->
      for category in @categories_json
        $('#categories').append "<div class='marker-desc'><div class='marker #{category.color}'></div><div class='desc'>#{category.name}</div></div>"
        $('#category_select').append "<option value='#{category.id}'>#{category.name}</option>"

    fillLeftPanelBuildingsList: (map_object_json)->
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

      hash = arrToHash(map_object_json)

      all = ''
      for letter, buildings of hash
        objects_by_letter = ''
        for b in buildings
          objects_by_letter += "<li data-map-object='#{ JSON.stringify(b) }' class='object_name'>#{ b.address.street }, #{ b.address.building_number }</li>"
        all += "<li class='objects_block'><div class='letter'>#{letter}</div><ul class='letter_objects'>#{objects_by_letter}</ul></li>"
      $('#letters_list').html all

    _filterObjectsByCategory: (categoryName) =>
      @mainMap.removeMarkers()
#      @mainMap.markerClusterer.clearMarkers()

      if categoryName == ''
        objectsFiltered = @map_object_json
      else
        objectsFiltered = (object for object in @map_object_json when object.category == categoryName)
      @fillLeftPanelBuildingsList(objectsFiltered)
      @createMapMarkersOnMainMap(objectsFiltered)

    initSearchField: ->
#       todo чосуь після реініціалізації не шукаю по нових даних бо датасет кешується https://github.com/twitter/typeahead.js/blob/master/src/typeahead.js
#       тому я ініціалізую новий датасет з рандомною назвою, але це фігово, бо всі список датасетів постійно збільшується

#       todo і ще добавити колбек якщо нічого не знайдено
      $('#search').typeahead('destroy')

      $('#search').typeahead
        name: 'streets' + Math.random()
        local: @map_object_json
        limit: 9

      $('#search').on 'typeahead:selected typeahead:autocompleted', (e, datum)=>
        @mainMap.setCenter(datum.location[0], datum.location[1])
        @mainMap.setZoom(18)


  window.fasady = new Fasady()
