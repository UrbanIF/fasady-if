$ ->
  class Fasady
    mainMap: null
    popupMap: null
    map_object_json: null
    categories_json: null

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

    renderAllMapObjects: ()=>
      @createMapMarkersOnMainMap(@map_object_json)
      @fillLeftPanelBuildingsList(@map_object_json)
      @initSearchField()

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
        mapObject = $(@).data('mapObject')
        self._fillMapObjectDescription mapObject
        self.mainMap.setCenter(mapObject.location[0], mapObject.location[1])
        self.mainMap.setZoom(18)

      $(document).on 'click', '.marker-desc', ->
        $this = $(this)
        if $this.hasClass('filter-reset')
          $('.marker-desc').removeClass('disactive')
        else
          $(".marker-desc:not('.filter-reset')").addClass('disactive')
          $this.removeClass('disactive')
        categoryName = $this.find('.desc').html()
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
      self = @
      markers = []
      for map_object in map_objects
        markers.push
          lat: map_object.location[0]
          lng: map_object.location[1]
          title: map_object.name
          icon: "/assets/marker-#{map_object.color}.png"
          infoWindow:
            content: "<img width='235' src='#{map_object.before_photo}'><p>#{map_object.name}</p>"
          click:
            ((map_object)=>
              (e)=>
                @_fillMapObjectDescription(map_object)
                @_openObjectDescription(map_object.location[0], map_object.location[1])
            )(map_object)
      #google.maps.event.addListener(marker, 'mouseover', function() {
      #  infowindow.open(map, this);
      #});
      #
      #// assuming you also want to hide the infowindow when user mouses-out
      #google.maps.event.addListener(marker, 'mouseout', function() {
      #  infowindow.close();
      #});
      @mainMap.addMarkers(markers)

    _fillMapObjectDescription: (map_object)=>
      $('#map_object_title').text(map_object.name)
      $('#map_object_address').text "#{ map_object.address.prefix } #{ map_object.address.street }, #{ map_object.address.building_number }#{ map_object.address.modifier }"
      $('#map_object_author_name').text map_object.user.name
      $('#map_object_author_avatar').prop('src', map_object.user.avatar)
      $('#map-object_image-before').prop('src', map_object.before_photo)
      $('#map-object_image-after').prop('src', map_object.after_photo)

    _openObjectDescription: (lat, lng)=>
      $('.right_container').addClass('show-object')
      i = 0
      interv = setInterval(
        =>
          @mainMap.refresh()
          @mainMap.setCenter(lat, lng)
          @mainMap.setZoom(18)
          i = i + 5
          if i > 600
            clearInterval(interv)
        5
      )

    _closeObjectDescription: =>
      $('.right_container').removeClass('show-object')
      i = 0
      center = @mainMap.getCenter()
      interv = setInterval(
        =>
          @mainMap.refresh()
          @mainMap.setCenter center.lat(), center.lng()
          i = i + 5
          if i > 600
            clearInterval(interv)
        5
      )



    fillCategories: ->
      for category in @categories_json
        $('#categories').append "<div class='marker-desc'><div class='marker #{category.color}'></div><div class='desc'>#{category.name}</div></div>"
        $('#category_select').append "<option value='#{category.id}'>#{category.name}</option>"
      $('#categories').append "<div class='marker-desc filter-reset'><div class='marker all'></div><div class='desc'>Усе</div></div>"

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

      if categoryName == 'Усе'
        objectsFiltered = @map_object_json
      else
        objectsFiltered = (object for object in @map_object_json when object.category == categoryName)
      @fillLeftPanelBuildingsList(objectsFiltered)
      @createMapMarkersOnMainMap(objectsFiltered)

    initSearchField: ->
#       todo чосуь після реініціалізації не шукаю по нових даних
#       todo і ще добавити колбек якщо нічого не знайдено
      $('#search').typeahead('destroy')

      log @map_object_json

      $('#search').typeahead
        name: 'streets'
        local: @map_object_json
        limit: 9

      $('#search').on 'typeahead:selected typeahead:autocompleted', (e, datum)=>
        @mainMap.setCenter(datum.location[0], datum.location[1])
        @mainMap.setZoom(18)


  window.fasady = new Fasady()
