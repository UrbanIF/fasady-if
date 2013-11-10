# todo тільки залогінені можуть додавати об’єкти
# todo пофіксити верстку в формі пошуку по доданих об’єктах
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
    $(window).on 'geocoded', =>
      console.log('geocoded')
      $('#popup_search').data('geocoded', 'geocoded')
      @validateForm()
      $('.popup_search_container .search_button').addClass('geocoded')

    # @initAutocomplete()

  submit: (e)=>
    e.preventDefault()
    console.log @validateForm()
    if @validateForm()
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
    obj.parents('.add-image').children('i').text(file.name)

  geocode: (e)=>
    e.preventDefault()
    GMaps.geocode
      address: "#{@searchInput.val()}, Івано-Франнківськ"
      callback: (results, status) =>
        if status is "OK"
          $(window).trigger('geocoded')
          latlng = results[0].geometry.location
          @moveMarker latlng
          @popupMap.setZoom 17
          @popupMap.set 'minZoom', 17
          @popupMap.set 'maxZoom', 17

  validateForm: ->
    a1 = @checkValue('#map_object_name')
    a2 = @checkValue('#category_select', '#dk_container_category_select')
    a3 = @checkValue('#popup_search')
    a4 = @checkValue('.add-image_input.left', '.btn.add-image.left')
    a5 = @checkValue('.add-image_input.right', '.btn.add-image.right')
    a6 = @checkValue('.popup_input.popup_comment')
    a7 = @checkAdress()
    a1 and a2 and a3 and a4 and a5 and a6 and a7

  checkAdress: ->
    if not $('#popup_search').data('geocoded')?
      @message 'неправильна адреса'
      false
    else
      true
  message: (message) ->
    console.log message
    alert(message)

  checkValue:(item, class_item) ->
    class_item = item if not class_item?
    $class_item = $("#{class_item}")
    $item = $("#{item}")
    $class_item.removeClass('empty')
    $class_item.addClass('empty') if not $item.val()
    # $("#{class_item}").one 'blur', @checkValue(item, class_item)

    !!$item.val()

$ ->
  window.objectForm = new ObjectForm()
