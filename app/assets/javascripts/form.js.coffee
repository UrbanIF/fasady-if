class ObjectForm
  constructor: ->
    alert('old browser') if window.formData?
    @form = $('#object_form')
    @form.on 'submit', @submit
    @popup = $('#add_object_popup')

    $('#add_object'). on 'click', @showForm

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

    @popupMap = (new window.Map('#add_object_map')).map
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

$ ->
  window.objectForm = new ObjectForm();