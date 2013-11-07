class ObjectForm
  constructor: ->
    alert('old browser') if window.formData?
    @form = $('#object_form')
    @form.on 'submit', @submit
    @popup = $('#add_object_popup')
    @lat = $('.lat')
    @lng = $('.lng')
    $('.add-image_input').on 'change', @fileSelected
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

    xhr.done =>
      @popup.removeClass('active')
      $('#addition_success-popup').addClass('active')
    xhr.fail =>
    xhr.always =>

  showForm: =>
    @popup.addClass('active')
    $('#category_select').dropkick()

    @popupMap = (new Map('#add_object_map')).map
    @marker = @popupMap.addMarker
      lat: 48.9260402
      lng: 24.74123899999995
      icon: '/assets/marker-add.png'
      draggable: true

    GMaps.on "dragend", @marker, @processMarker
    GMaps.on "click", @popupMap.map, @processMarker


  processMarker: (event) =>
    lat = event.latLng.lat()
    lng = event.latLng.lng()
    @marker.setPosition(new google.maps.LatLng(lat, lng))
    @popupMap.setCenter lat, lng
    @lat.val lat
    @lng.val lng

  fileSelected: ->
    obj = $(@)
    file = obj.prop('files')[0]
    obj.parents('.add-image').text(file.name)

$ ->
  window.objectForm = new ObjectForm()