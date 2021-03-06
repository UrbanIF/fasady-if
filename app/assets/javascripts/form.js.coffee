# todo пошук не працює якщо назву введено з орфографічними помилками
class ObjectForm
  constructor: ->
    @form = $('#object_form')
    @form.on 'submit', @submit
    @popup = $('#add_object_popup')
    @lat = $('.lat')
    @lng = $('.lng')
    @searchInput = $('#popup_search')
    @bindEvents()

  bindEvents: ->
    $('.search_button').on 'click', @geocode
    $('.add-image_input').on 'change', @fileSelected
    $('#add_object'). on 'click', @showForm
    $(window).on 'geocoded', (e, data)->
      $('.popup_search_container').removeClass('invalid').addClass('valid')
      adress = ''
      prefix = ''
      if data['route']?
        prefix = (/вулиця/i.exec(data['route']))
        prefix = prefix[0] if prefix? and prefix[0]?
        adress = data['route'].replace /вулиця /i, ''
      $('.street').val adress
      $('.route').val data['street_number']
      $('.prefix').val prefix
      $('#popup_search').data('geocoded', 'geocoded')

    $(window).on 'geocoding_error', =>
      message 'Адресу не знайдено'
      $('.popup_search_container').addClass('invalid').removeClass('valid')
      $('#popup_search').removeData('geocoded')
      $('.street').val ''
      $('.route').val ''
      $('.prefix').val ''

    # @initAutocomplete()

  submit: (e)=>
    e.preventDefault()
    form_valid = @validateForm()
    console.log form_valid
    if form_valid
      $('#submit_object').prop('disabled', true)
      xhr = $.ajax
        type: "POST"
        url: @form.prop('action')
        data: new FormData(@form[0])
        cache: false
        contentType: false
        processData: false

      xhr.done (json)=>
        # window.fasady.map_object_json.push json          # add to GLOBAL objects list
        # window.fasady.renderAllMapObjects()
        $('#user_added_objects').append "<li>#{json.name}, #{json.address.prefix} #{json.address.street}, #{json.address.building_number}</li>"
        @popup.removeClass('active')
        @resetForm()
        $('#addition_success-popup').addClass('active')
      xhr.fail (xhr, error)=>
        console.log error
        switch xhr.status
          when 422 then message 'Перевірте правельність заповнення форми та спробуйте ще раз'

      xhr.always =>
        $('#submit_object').removeProp('disabled')

    else
      message 'Заповніть всі поля, та підтвердіть адресу'

  resetForm: ->
    @form.find("input[type=text], input[type=file], textarea").val('')
    $('.add-image.left i').text('Фото існуючого стану')
    $('.add-image.right i').text('Проект-пропозиція до об’єкта')
    $('#category_select option:eq(0)').prop('selected','selected')
    $('.popup_search_container').removeClass('valid')
    $('#popup_search').removeData('geocoded')
    $('#category_select').dropkick 'reset'

  showForm: =>
    if user.loged_in
      @popup.addClass('active')
      $('#category_select').dropkick()
      @popupMap = (new Map('#add_object_map')).map
    else
      $('#login').data('showForm', 'showForm').trigger 'click'
    # @popupMap.set 'disableDefaultUI', true
    # GMaps.on "click", @popupMap.map, @processMarker
    # GMaps.on "place_changed", @autocomplete, =>

  addMarker: ->
    @marker = @popupMap.addMarker
      lat: 48.9228757160567
      lng: 24.71033066511154
      icon: window.markers.add
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
    if @searchInput.val().trim() is  ''
      $(window).trigger('geocoding_error')
      return false

    GMaps.geocode
      address: "#{@searchInput.val()}, Івано-Франнківськ"
      callback: (results, status) =>
        if status is "OK"
          for component in results[0].address_components
            street_number = component.short_name if 'street_number' in component.types
            route = component.short_name if 'route' in component.types

          $(window).trigger('geocoded', [{street_number: street_number, route: route}])
          latlng = results[0].geometry.location
          @moveMarker latlng
          @popupMap.setZoom 17
          @popupMap.set 'minZoom', 17
          @popupMap.set 'maxZoom', 17
        else
          $(window).trigger('geocoding_error')

  validateForm: ->
    a1 = @checkValue('#map_object_name')
    a2 = @checkValue('#category_select', '#dk_container_category_select')
    a3 = @checkValue('#popup_search')
    a4 = @checkValue('.add-image_input.left', '.btn.add-image.left')
    a5 = @checkValue('.add-image_input.right', '.btn.add-image.right')
    a6 = @checkValue('.popup_input.popup_comment')
    a1 and a2 and a3 and a4 and a5 and a6 and @checkAdress()

  checkAdress: ->
    if not $('#popup_search').data('geocoded')?
      message 'Адресу не знайдено'
      return false
    else if not $('.route').val()
        message 'Введіть номер будинку'
        return false

    true

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
