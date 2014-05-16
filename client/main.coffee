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



UI.body.events {
  'click .close-modal': (e)->
    $(e.target).closest('.aura-modal').removeClass('_opened')
    $('.modal-ovrl').removeClass('_visible')

  'click .post-modal form button': (e)->
    e.preventDefault()
    if $(e.target).closest('form').valid()
      date = new Date()
      News.insert {
        date: date
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

  Meteor.setTimeout ->

    $('#main-cont').fullpage({
      anchors: ['about', 'service', 'gallery', 'capabilities', 'news', 'contacts']
      menu: '#top-menu'
      scrollOverflow: true
      afterLoad: (link, dir)->
        MainCtrl.pageLoaded(link, dir)
        MainCtrl.animatePage($('[data-anchor="' + link + '"]'))
        if link is 'gallery'
          if !$('.gallery-cont').hasClass('_init')
            pic = Gallery.findOne().main
            id = Gallery.findOne()._id
            title = Gallery.findOne().title
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
      afterSlideLoad: (anchorLink, index, slideAnchor, slideIndex)->
        $('[data-anchor="' + slideAnchor + '"]').find('.desc').addClass('_animated')
        $('[data-anchor="' + slideAnchor + '"]').find('button').addClass('_animated')
        $('.slider-controls').find('ul li a').removeClass('_active')
        $('.slider-controls').find('ul li').eq(slideIndex).find('a').addClass('_active')
      onSlideLeave: (anchorLink, index, slideIndex, dir)->
        $('.slide').eq(slideIndex).find('.desc').removeClass('_animated')
        $('.slide').eq(slideIndex).find('button').removeClass('_animated')
    })
  , 1000


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
  console.log 'galleryRendered'
  $('.carousel-cont').find('.thumb').first().addClass('_active')
  Session.set('gallerySort', 'all')


Template.gallery.helpers {
  gallery: ->
    if Session.get('gallerySort') is 'all'
      Gallery.find()
    else
      Gallery.find({'category': Session.get('gallerySort')})

  galleryPrev: ->
    if Session.get('currentAlbum')
      Gallery.findOne(Session.get('currentAlbum'))
}

Template.gallery.events {
  'click .sort>span': (e)->
    $('.sort>span').removeClass('active')
    $(e.target).addClass('active')
    Session.set 'gallerySort', $(e.target).data('sort')

  'click .carousel-cont .thumb': (e)->
    targetId = $(e.target).closest('li').data('id')
    album = Gallery.findOne(targetId)
    MainCtrl.gallery.showPic(album.main)
    Session.set 'currentAlbum', targetId
    Meteor.setTimeout ->
      $('.top-prev').find('[data-image="' + album.main + '"]').addClass('_active')
    , 500
    $('.gallery-cont .preview').find('.title').html(album.title)

  'click .top-prev li': (e)->
    image = $(e.target).data('image')
    $('.top-prev li').removeClass('_active')
    $(e.target).addClass('_active')
    MainCtrl.gallery.showPic(image)

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
  Meteor.setTimeout ->
    $('#news-section').find('aside ul li').first().addClass('_active')
  , 500

Template.news.helpers {
  newsList: ->
    News.find()
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

  if Session.get('mapLoaded') is false

    Meteor.setTimeout ->

      script = document.createElement("script")
      script.type = "text/javascript"
      script.src = "http://maps.google.com/maps/api/js?sensor=false&libraries=places&callback=initializeMap"
      document.body.appendChild(script)
      Session.set('mapLoaded', true)
    ,1500


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



MainCtrl = {

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

    else if link is 'contacts'

      'rgba(104, 206, 248, .7)'

  gallery:

    showPic: (img)->
      MainCtrl.showLoader()
      $('<img>').attr('src', 'http://d9bm0rz9duwg1.cloudfront.net/' + img + '.jpg').load ->
        MainCtrl.hideLoader()
        console.log 'loaded'
        $('.pic').addClass('_old')
        $('<div>').addClass('pic').css('background-image', 'url(http://d9bm0rz9duwg1.cloudfront.net/' + img + '.jpg)').prependTo('.gallery-cont')
        Meteor.setTimeout ->
          $('._old').addClass('_removed')
        , 100
        Meteor.setTimeout ->
          $('._old').remove()
        , 600
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