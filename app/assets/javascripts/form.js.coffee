class ObjectForm
  constructor: ->
    alert('old browser') if window.formData?
    @form = $('#object_form')
    @form.on 'submit', @submit
    @popup = $('#add_object_popup')
    @lat = $('.lat')
    @lng = $('.lng')
    @searchInput = $('#popup_search')
    $('.search_button').on 'click', @geocode
    $('.add-image_input').on 'change', @fileSelected
    $('#add_object'). on 'click', @showForm

    # @initAutocomplete()

  submit: (e)=>
    e.preventDefault()
    xhr = $.ajax
      type: "POST"
      url: @form.prop('action')
      data: new FormData(@form[0])
      cache: false
      contentType: false
      processData: false

    xhr.done ->
      @popup.removeClass('active')
      $('#addition_success-popup').addClass('active')
    xhr.fail ->
    xhr.always ->

  showForm: =>
    @popup.addClass('active')
    $('#category_select').dropkick()
    @popupMap = (new Map('#add_object_map')).map
    # @popupMap.set 'disableDefaultUI', true
    # GMaps.on "click", @popupMap.map, @processMarker
    # GMaps.on "place_changed", @autocomplete, =>

  addMarker: ->
    @marker = @popupMap.addMarker
      lat: 48.9228757160567
      lng: 24.71033066511154
      icon: '/assets/marker-add.png'
      draggable: true
    GMaps.on "dragend", @marker, @processMarker

  processMarker: (event) =>
    @moveMarker(event.latLng)

  moveMarker: (latLng)=>
    @addMarker() if not @marker?
    lat = latLng.lat()
    lng = latLng.lng()
    @marker.setPosition(latLng)
    @popupMap.setCenter lat, lng
    @lat.val lat
    @lng.val lng

  fileSelected: ->
    obj = $(@)
    file = obj.prop('files')[0]
    obj.parents('.add-image').text(file.name)

  geocode: (e)=>
    e.preventDefault()
    GMaps.geocode
      address: "#{@searchInput.val()}, Івано-Франнківськ"
      callback: (results, status) =>
        if status is "OK"
          latlng = results[0].geometry.location
          @moveMarker latlng
          @popupMap.setZoom 17
          @popupMap.set 'minZoom', 17
          @popupMap.set 'maxZoom', 17

  # initAutocomplete: ->
  #   location = new google.maps.LatLng(48.9260402, 24.74123899999995)
  #   defaultBounds = new google.maps.LatLngBounds(location)
  #   options =
  #     bounds: defaultBounds
  #     types: ["geocode"]

  #   @autocomplete = new google.maps.places.Autocomplete($("#popup_search")[0], options)

$ ->
  window.objectForm = new ObjectForm();