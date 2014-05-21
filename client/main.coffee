Session.setDefault('mapLoaded', false)
Session.setDefault('gallerySort', 'all')

Meteor.subscribe 'gallery'

Meteor.subscribe 'news', ->
  id = News.findOne()._id
  Session.set 'currentNew', id
#@allRendered = {
#  state: []
#  ready: false
#}




@initYandexMap = ->
  myMap = new ymaps.Map "map", {
    center: [60.060442, 30.367514],
    zoom: 14
  }
  myPlacemark = new ymaps.Placemark([60.060442, 30.367514], { content: 'Северная палитра', balloonContent: 'Северная палитра' })
  myMap.geoObjects.add(myPlacemark)

UI.body.events {
  'click .close-modal': (e)->
    $(e.target).closest('.aura-modal').removeClass('_opened')
    $('.modal-ovrl').removeClass('_visible')

  'click .auraModal .close-modal': (e)->
    $(e.target).closest('.auraModal').removeClass('_opened')
    $('.modal-ovrl').removeClass('_visible')

  'click .post-modal form button': (e)->
    e.preventDefault()
    if $(e.target).closest('form').valid()
      date = new Date()
      dateParced = Date.parse(date)
      News.insert {
        date: date
        dateParced: dateParced
        title: $(e.target).closest('form').find('#title').val()
        content: $(e.target).closest('form').find('#content').val()
      }, ->
        $('.aura-modal').removeClass('_opened')
        $('.modal-ovrl').removeClass('_visible')
    else
      Aura.notify('Пожалуйста заполните правитьно форму!')
}

Template.main.rendered = ->

#  $('#top').find('.slide').attr('data-stellar-background-ratio', .6)
#  $.stellar()
#  templatesRendered.loaded()

  MainCtrl.loader = new CanvasLoader('loader')
  MainCtrl.loader.setColor('#ffffff')
  MainCtrl.loader.setDiameter(56)
  MainCtrl.loader.setDensity(66)
  MainCtrl.loader.setRange(1)
  MainCtrl.loader.setFPS(51)
  mainLoaded = imagesLoaded($('body'))
  mainLoaded.on 'always', ->
    $('#top').find('.slide').find('.desc').addClass('_animated')
    $('#top').find('.slide').find('button').addClass('_animated')
    console.log 'all loaded'
  mainLoaded.on 'progress', (instance, image)->
    console.log 'pic loaded'

#  Meteor.setTimeout ->
#
#    MainCtrl.
#
#  , 1000

UI.body.events {
  'click #top .slide .container button': (e)->
    target = $(e.target).closest('button').data('target')
    console.log 'clicked button' + target
    $.fn.fullpage.moveTo(target)
}


Template.top.helpers {
  top: ->
    Pages.findOne({name: 'top'})
}



Template.service.helpers {
  service: ->
    Pages.findOne({name: 'service'})
}

Template.capabilities.helpers {
  capabilities: ->
    Pages.findOne({name: 'capabilities'})
}

Template.contacts.helpers {
  contacts: ->
    Pages.findOne({name: 'contacts'})
}

Template.gallery.rendered = ->
#  templatesRendered.loaded()
  console.log 'galleryRendered'
  $('.carousel-cont').find('.thumb').first().addClass('_active')
  Session.set('gallerySort', 'all')


Template.gallery.helpers {
  gallery: ->
    if Session.get('gallerySort') is 'all'
      Gallery.find({}, {sort: {'order': 1}})
    else
      Gallery.find({'category': Session.get('gallerySort')}, {sort: {'order': 1}})

  galleryPrev: ->
    if Session.get('currentAlbum')
      Gallery.findOne(Session.get('currentAlbum'), {sort: {'order': 1}})

  getThumb: (img)->

    splited = img.split('.')
    thumb = splited[0] + '_thumb.' + splited[1]
    thumb

}

Template.gallery.events {
  'click .sort>span': (e)->
    $('.sort>span').removeClass('active')
    $(e.target).addClass('active')
    Session.set 'gallerySort', $(e.target).data('sort')

  'click .carousel-cont .thumb': (e)->
    targetId = $(e.target).closest('li').data('id')
    album = Gallery.findOne(targetId)
    MainCtrl.gallery.showPic(album.images[0])
    Session.set 'currentAlbum', targetId
    Meteor.setTimeout ->
      $('.top-prev').find('[data-image="' + album.main + '"]').addClass('_active')
    , 500
    $('.gallery-cont .preview').find('.title').html(album.title)

  'click .top-prev li': (e)->
    image = $(e.target).data('image')
    $('.top-prev li').removeClass('_active')
    MainCtrl.gallery.showPic(image)
    $(e.target).addClass('_active')

  'click .aura-edit-image': ->
    $('#galleryAdmin').addClass('_opened')
    $('.modal-ovrl').addClass('_visible')


}

Template.capabilities.events {
  'click .circle': (e)->
    $ovrl = $('#capabilities-section').find('.ovrl')
    targetIndex = $(e.target).closest('.circle').index() - 5
    $ovrl.find('.cap-cont>ul>li').removeClass('_active')
    $ovrl.find('.cap-cont>ul>li').eq(targetIndex).addClass('_active')
    $ovrl.find('nav ul li').removeClass('_active')
    $ovrl.find('nav ul li').eq(targetIndex).addClass('_active')
    $ovrl.addClass('_opened')
  'click .ovrl nav ul li': (e)->
    index = $(e.target).closest('li').index()
    $('.ovrl nav ul li').removeClass('_active')
    $(e.target).closest('li').addClass('_active')
    $('.ovrl').find('.cap-cont>ul>li').removeClass('_active')
    $('.ovrl').find('.cap-cont>ul>li').eq(index).addClass('_active')
  'click .close-it': ->
    $('#capabilities-section').find('.ovrl').removeClass('_opened')
    $('.cap-cont>ul>li').removeClass('_active')

}

Template.news.rendered = ->
#  templatesRendered.loaded()
  Meteor.setTimeout ->
    $('#news-section').find('aside ul li').first().addClass('_active')
  , 500

Template.news.helpers {
  newsList: ->
    News.find({}, {sort: {dateParced: -1}})
  firstNew: ->
    News.findOne(Session.get('currentNew'))
  getDate: (date)->
    moment(date).lang('ru').format('DD MMMM YYYY')
}

Template.news.events {
  'click aside ul li': (e)->
    target = $(e.target).closest('li')
    id = target.data('id')
    $('#news-section').find('aside ul li').removeClass('_active')
    target.addClass('_active')
    $('#news-section').find('article').removeClass('_animated')
    Meteor.setTimeout ->
      Session.set 'currentNew', id
      $('#news-section').find('article').addClass('_animated')
    , 400

  'click .new': ->
    $('.post-modal').addClass('_opened')
    $('.modal-ovrl').addClass('_visible')

  'click aside .delete': (e)->
    id = $(e.target).closest('li').data('id')
    News.remove id

}

Template.contacts.rendered = ->

  console.log 'contacts rendered'

  ymaps.ready(initYandexMap)

#  if Session.get('mapLoaded') is false
#
#    Meteor.setTimeout ->
#
#      script = document.createElement("script")
#      script.type = "text/javascript"
#      script.src = "http://maps.google.com/maps/api/js?sensor=false&libraries=places&callback=initializeMap"
#      document.body.appendChild(script)
#      Session.set('mapLoaded', true)
#    ,1500


Template.service.events {
  'click [data-toggle]': (e)->
    clicked = $(e.target).closest('[data-toggle]')
    target = clicked.data('toggle')
    $('#' + target).addClass('_opened')
  'click .close-it': ->
    $('.service-cont').removeClass('_opened')
  'click .arrows.right': (e)->
    cont = $(e.target).closest('.service-cont')
    length = $('.service-cont').length
    offset = 2
    index = cont.index()
    cont.removeClass('_opened')
    if index is offset + 0
      Meteor.setTimeout ->
        $('.service-cont').eq(2).addClass('_opened')
      , 1000
    else
      Meteor.setTimeout ->
        $('.service-cont').eq(index - offset - 1).addClass('_opened')
      , 1000
  'click .arrows.left': (e)->
    cont = $(e.target).closest('.service-cont')
    length = $('.service-cont').length
    offset = 2
    index = cont.index()
    cont.removeClass('_opened')
    console.log index
    if index - 1 is 0
      Meteor.setTimeout ->
        $('.service-cont').eq(2).addClass('_opened')
      , 1000
    else
      Meteor.setTimeout ->
        $('.service-cont').eq(index - 2).addClass('_opened')
      , 1000
  'click .links-cont li a': (e)->
    clicked = $(e.target).closest('a')
    target = clicked.data('target')
    if $('.gallery-cont .carousel-cont').find('[data-sub="' + target +  '"]').length > 0
      $.fn.fullpage.moveTo(3)
      $('.gallery-cont .carousel-cont').find('[data-sub="' + target +  '"]').first().trigger('click')
}


Template.auraModal.helpers {
  itemList: ->
    Gallery.find({}, {sort: {'order': 1}})

  getThumb: (img)->

    splited = img.split('.')
    thumb = splited[0] + '_thumb.' + splited[1]
    thumb
}

Template.auraModal.events {
  'click aside li': (e)->
    id = $(e.target).closest('li').data('id')
    Session.set 'auraModalList', id
    Meteor.setTimeout ->
      $( "#gallery-items-thumbs" ).sortable({
        change: (e, ui)->
          MainCtrl.galleryAdmin.reorderPics()
      })
    , 1000
  'click aside li .delete': (e)->
    clicked = $(e.target).closest('li')
    id = clicked.data('id')
    images = Gallery.findOne({'_id': id}).images
    console.log images

    Meteor.call 'deletePics', images, (err, res)->
      if err

        Aura.notify 'Изображения не удалены:( Может и к лучшему))'

      else

        if res

          Gallery.remove id
          Aura.notify 'Альбом удален!'

        else

          Aura.notify 'Изображения не удалены:( Ошибка на стороне сервера'

  'click aside .add-new': (e)->

    Gallery.insert {
      category: 'home'
      subcategory: 'cafe',
      images: [],
      title: ''
    }, (id)->
      console.log id

  'keypress #albumName': (e)->
    Meteor.setTimeout ->
      id = $('#albumId').val()
      text = $(e.target).val()
      Gallery.update id, {$set: {'title': text}}
    , 200
}

Template.auraModal.rendered = ->
  $('#gallery-albums-list').sortable({
    stop: (e, ui)->
      MainCtrl.galleryAdmin.reorderAlbums()
  })
  if Session.get('auraModalList') is 'initial'
    UI.insert(UI.renderWithData(Template.galleryList, Gallery.findOne()), $('.auraModal').find('.list-wrap').get(0))
  else
    UI.insert(UI.renderWithData(Template.galleryList, Gallery.findOne({'_id': Session.get('auraModalList')})), $('.auraModal').find('.list-wrap').get(0))

Template.galleryList.helpers {
  item: ->
    if Session.get('auraModalList')
      Gallery.findOne('_id': Session.get('auraModalList'))
    else
      Gallery.findOne()
}

Template.galleryList.events {
  'click #gallery-items-thumbs li .delete': (e)->
    clicked = $(e.target).closest('li')
    id = $('#albumId').val()
    image = _.last(clicked.find('.img').css('background-image').split('/')).replace(')', '')
    console.log image

    Meteor.call 'deletePic', image, (err, res)->
      if err

        Aura.notify 'Изображение не удалено:( Может и к лучшему))'

      else

        if res


          clicked.remove()
          images = []
          $('#galleryAdmin').find('.list-cont li.item').each ->

            if !$(this).hasClass('ui-sortable-placeholder')
              img = $(this).find('.img').css('background-image').split('/')
              name = _.last(img).replace(')', '')
              images.push name
          Gallery.update id, {$set: {'images': images}}
          Aura.notify 'Изображение удалено!'

        else

          Aura.notify 'Изображение не удалено:( Ошибка на стороне сервера'

}


Template.galleryList.rendered = ->

  Meteor.setTimeout ->
    $( "#gallery-items-thumbs" ).sortable({
      stop: (e, ui)->
        MainCtrl.galleryAdmin.reorderPics()
    })
  , 1000


@MainCtrl = {

  init: ->

    console.log 'Main controller initialized'

    assets = []

    page = Pages.findOne({name: 'top'})
    assets.push page.image1
    assets.push page.image2
    assets.push page.image3

    new Loader assets, MainCtrl.fullPage

  showLoader: ->

    @loader.show()
    $('#loader').addClass('_visible')

  hideLoader: ->
    $('#loader').removeClass('_visible')
    Meteor.setTimeout =>
      @loader.hide()
    , 500

  animatePage: (elem)->

    $allElems = elem.find('[data-animate]')
    $allElems.each ->
      speed = $(this).data('animate')
      $elem = $(this)
      setTimeout ->
        $elem.addClass('_animated')
      , 1000 * parseFloat(speed, 10)

  pageLoaded: (link, dir)->

    color = @getColor(link)

    $('header').css('background', color)



  getColor: (link)->

    if link is 'about'

      'rgba(168, 166, 210, .7)'

    else if link is 'service'

      'rgba(248, 121, 176, .7)'

    else if link is 'gallery'

      'rgba(109, 255, 109, .7)'

    else if link is 'capabilities'

      'rgba(104, 206, 248, .7)'

    else if link is 'news'

      'rgba(168, 166, 210, .7)'

    else if link is 'contacts'

      'rgba(109, 255, 109, .7)'

  gallery:

    showPic: (img)->
      MainCtrl.showLoader()
      $('<img>').attr('src', 'http://d9bm0rz9duwg1.cloudfront.net/' + img).load ->
        MainCtrl.hideLoader()
        console.log 'loaded'
        $('.pic').addClass('_old')
        $('<div>').addClass('pic').css('background-image', 'url(http://d9bm0rz9duwg1.cloudfront.net/' + img + ')').prependTo('.gallery-cont')
        Meteor.setTimeout ->
          $('._old').addClass('_removed')
        , 100
        Meteor.setTimeout ->
          $('._old').remove()
        , 600

  galleryAdmin: {

    reorderAlbums: ->

      newOrder = []

      $('#galleryAdmin').find('aside li').each ->
        obj = {
          id: $(this).data('id')
          index:$(this).index()
        }
        newOrder.push obj

      newOrder.forEach (item)->
        Gallery.update item.id, {$set: {'order': item.index}}

      console.log 'reordered'

    reorderPics: ->

      reordered = []
      id = $('#albumId').val()

      $('#galleryAdmin').find('.list-cont li.item').each ->

        if !$(this).hasClass('ui-sortable-placeholder')
          img = $(this).find('.img').css('background-image').split('/')
          name = _.last(img).replace(')', '')
          reordered.push name

      Gallery.update id, {$set: {'images': reordered}}, ->

        $('.carousel-cont').find('[data-id="' + id + '"]').trigger('click')

      console.log 'reordered'

  }

  fullPage: ->

    $('#main-cont').fullpage({
      anchors: ['about', 'service', 'gallery', 'capabilities', 'news', 'contacts']
      menu: '#top-menu'
      scrollOverflow: true
      normalScrollElements: '.auraModal', '#map'
      afterLoad: (link, dir)->
        MainCtrl.pageLoaded(link, dir)
        MainCtrl.animatePage($('[data-anchor="' + link + '"]'))
        if link is 'gallery'
          if !$('.gallery-cont').hasClass('_init')
            album = Gallery.findOne({'order': 0})
            pic = album.images[0]
            id = album._id
            title = album.title
            MainCtrl.gallery.showPic(pic)
            $('.gallery-cont').addClass('_init')
            $('.gallery-cont .preview').find('.title').html(title)
        if link is 'capabilities'
          if !$('.tip').hasClass('_watched')
            Meteor.setTimeout ->
              $('.tip').addClass('_visible')
            , 3000
            Meteor.setTimeout ->
              $('.tip').removeClass('_visible').addClass('_watched')
            , 6000
      resize: false
      afterSlideLoad: (anchorLink, index, slideAnchor, slideIndex)->
        $('[data-anchor="' + slideAnchor + '"]').find('.desc').addClass('_animated')
        $('[data-anchor="' + slideAnchor + '"]').find('button').addClass('_animated')
        $('.slider-controls').find('ul li a').removeClass('_active')
        $('.slider-controls').find('ul li').eq(slideIndex).find('a').addClass('_active')
      onSlideLeave: (anchorLink, index, slideIndex, dir)->
        $('.slide').eq(slideIndex).find('.desc').removeClass('_animated')
        $('.slide').eq(slideIndex).find('button').removeClass('_animated')
    })
    $('#top').find('.slide').first().find('.container').find('.desc').addClass('_animated')
    $('#top').find('.slide').first().find('.container').find('button').addClass('_animated')

}


@initializeMap = ->

  myLatlng = new google.maps.LatLng(55.893921, 37.720258)

  mapOptions = {
    zoom: 15,
    center: myLatlng
    zoomControl:true,
    zoomControlOpt:{
      style:"MEDIUM",
      position:"RIGHT_TOP"
    },
    panControl:true,
    streetViewControl:false,
    mapTypeControl:false,
    overviewMapControl:false,
    scrollwheel:false
  }

  styles = [
    {
      stylers:[
        { hue:"#6599c0" },
        { saturation:120 }
      ]
    },
    {
      featureType:"road",
      elementType:"geometry",
      stylers:[
        { lightness:100 }      ]
    },
    {
      featureType:"road",
      elementType:"labels",
      stylers:[
        { hue:"green" },
        { saturation:50 }
      ]
    }
  ]

  styledMap = new google.maps.StyledMapType styles, {name: "Styled Map"}

  @map  = new google.maps.Map document.getElementById('map'), mapOptions

  @map.mapTypes.set('map_style', styledMap)

  @map.setMapTypeId('map_style')

  marker = new google.maps.Marker({
    position: myLatlng,
    map: map
  })




#@loader = (callback)->
#
#  max = 1
#  loaded: 0
#  progress: (ins)->
#    console.log ins + ' loaded'
#    @loaded++
#    if @loaded >= @max
#      @ready()
#  ready: ->


class @TemplatesRendered

  constructor: (@max, @callback)->
    console.log 'TRinit'

  count: 0

  loaded: ->

    console.log 'template loaded yo'

    @count++

    if @count >= @max

      console.log 'all templates loaded!'

      @callback()


class @Loader

  constructor: (@assets, @callback)->

    @max = @assets.length

    @init()

  count: 0

  progress: (ins)->

    console.log 'файл' + ins + 'загружен! Ура'

    @count++

    if @count >= @max

      $('.preloading').addClass('_loaded')
      @callback()

  init: ->

    console.log @assets

    _.each @assets, (img)=>

      $('<img>').attr('src', 'http://d9bm0rz9duwg1.cloudfront.net/' + img).load =>

        console.log 'img loaded'

        @progress(img)




Deps.autorun ->

  if Session.get('pagesReady') is true

    MainCtrl.init()









