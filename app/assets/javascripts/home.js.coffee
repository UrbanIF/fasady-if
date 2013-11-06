log = (a)-> console.log(a)

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

    #   $(document).on 'click', '#submit_object', =>
    #     $.ajax
    #       method: 'POST'
    #       url: '/api/map_objects.json'
    #       data:
    #         map_object:
    #           name:          $('#map_object_name').val()
    #           category_id:   $('#category_select').val()
    #           location:      [ @popupMap.markers[0].position.lb, @popupMap.markers[0].position.mb ]
    #           address:
    #             prefix: 'вул.'
    #             street: 'Маланюка'
    #             building_number: 10
    #             modifier: ''

    # #          before_photos: [ {link: 'test' }]
    # #          after_photos:  [ {link: 'test' }]

    #     .done ()->
    #
    #     .fail()

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
            content: "<p>#{map_object.name}</p>"
          click: (e)=>
            $('.right_container').addClass('show-object')
            i = 0
            interv = setInterval(
              =>
                @mainMap.refresh()
                @mainMap.setCenter(e.position.lb, e.position.mb)
                @mainMap.setZoom(18)
                i = i + 5
                if i > 600
                  clearInterval(interv)
              5
            )
      @mainMap.addMarkers(markers)

    fillCategories: ->
      for category in @categories_json
        $('#categories').append "<div class='marker-desc'><div class='marker #{category.color}'></div><div class='desc'>#{category.name}</div></div>"
        $('#category_select').append "<option value='#{category.id}'>#{category.name}</option>"
      $('#categories').append "<div class='marker-desc'><div class='marker yellow'></div><div class='desc'>Усе</div></div>"

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
      @mainMap.removeMarkers()
      @mainMap.markerClusterer.clearMarkers()

      if categoryName == 'Усе'
        objectsFiltered = @map_object_json
      else
        objectsFiltered = (object for object in @map_object_json when object.category == categoryName)
      @createMapMarkersOnMainMap(objectsFiltered)

    initSearchField: ->
      $('#search').typeahead
        name: 'streets'
        local: @map_object_json
        limit: 10

      $('#search').on 'typeahead:selected typeahead:autocompleted', (e, datum)=>
        @mainMap.setCenter(datum.location[0], datum.location[1])
        @mainMap.setZoom(18)


  window.fasady = new Fasady()
