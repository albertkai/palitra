Session.setDefault('mapLoaded', false)
Session.setDefault('gallerySort', 'all')
Session.setDefault('auraModalReady', false)
Session.setDefault('auraModalList', 'initial')
Session.setDefault('galleryReady', false)
Session.setDefault('mainRendered', false)

Meteor.subscribe 'gallery', ->
  Session.set 'galleryReady', true

Meteor.subscribe 'news', ->
  count = News.find({}).count()
  id = News.find({}, {sort: {dateParsed: -1}}).fetch()[count - 1]._id
  Session.set 'currentNew', id
#@allRendered = {
#  state: []
#  ready: false
#}

Deps.autorun ->
  if Session.get('pagesReady') and Session.get('mainRendered')
    console.log 'rerender'
    $('#top').empty()
    UI.insert(UI.renderWithData(Template.top, {top: Pages.findOne({name: 'top'}, {reactive: false})}), $('#top').get(0))


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

      'rgba(248, 121, 176, .7)'

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

      console.log reordered

      Gallery.update id, {$set: {'images': reordered}}, ->

        $('.carousel-cont').find('[data-id="' + id + '"]').trigger('click')

      console.log 'reordered'

  }

  fullPage: ->

    $('#main-cont').fullpage({
      anchors: ['about', 'service', 'gallery', 'capabilities', 'news', 'contacts']
      menu: '#top-menu'
      scrollOverflow: true
      normalScrollElements: '.auraModal, #map, .admin-panel .wrap, #news-section aside ul'
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
          $('.gallery-cont .preview').addClass('_opened')
          Meteor.setTimeout ->
            $('.gallery-cont .preview').removeClass('_opened')
          , 2000
        if link is 'capabilities'
          if !$('.tip').hasClass('_watched')
            Meteor.setTimeout ->
              $('.tip').addClass('_visible')
            , 3000
            Meteor.setTimeout ->
              $('.tip').removeClass('_visible').addClass('_watched')
            , 6000
        prevTop = 0
        Meteor.setInterval ->
          index = .65
          top = parseInt $('#main-cont').css('top'), 10
          if top isnt prevTop and top < 1200
            prevTop = top
            $('#top').find('.slide').css('background-position', '0 ' + (index * top * -1) + 'px')
        , 13
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
    $('.slides').find('.desc').addClass('_animated')
    $('.slides').find('button').addClass('_animated')
    if window.location.href.split('#')[1]
      target = window.location.href.split('#')[1]
      $.fn.fullpage.moveTo(target)

  svgLoader: {
    max: 5
    count: 0
    step: 3
    update: (add)->
      shift = @count * @step
      range = add * @step
      for num in [0..range]
        do (num)->
          f = ->
            number = num
            if shift + number < 15
              $('#svg-logo').find('>g').get(shift + number).getElementsByTagName('g')[0].setAttribute('class', '_done')
          _.delay(f, _.random(0, 500))
      @count += add

  }

}




if Response.deviceW() < 900

  window.location = "http://okrasmdf.ru";
  return false;


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

  Session.set('mainRendered', true)

  MainCtrl.loader = new CanvasLoader('loader')
  MainCtrl.loader.setColor('#ffffff')
  MainCtrl.loader.setDiameter(56)
  MainCtrl.loader.setDensity(66)
  MainCtrl.loader.setRange(1)
  MainCtrl.loader.setFPS(51)
  MainCtrl.svgLoader.update(2)


UI.body.events {
  'click #top .slide .container button': (e)->
    target = $(e.target).closest('button').data('target')
    console.log 'clicked button' + target
    $.fn.fullpage.moveTo(target)
}

#
#Template.top.helpers {
#  top: ->
#    Pages.findOne({name: 'top'})
#
#}


Template.service.helpers {
  service: ->
    Pages.findOne({name: 'service'})
}

Template.service.events {
  'mouseenter .first-cont .row>div': (e)->
    $(e.currentTarget).find('.img').addClass('animated').addClass('bounce')
  'mouseleave .first-cont .row>div': (e)->
    $(e.currentTarget).find('.img').removeClass('animated').removeClass('bounce')
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
    $('#galleryAdmin').find('aside li').first().trigger 'click'


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
    if img
      splited = img.split('.')
      thumb = splited[0] + '_thumb.' + splited[1]
      thumb
}

Template.auraModal.events {
  'click aside li': (e)->
    id = $(e.target).closest('li').data('id')
    Session.set 'auraModalList', id
    category = Gallery.findOne({_id: id}).category
    subcategory = Gallery.findOne({_id: id}).subcategory
    $('#categoryChoose').val(category)
    $('#subcategoryChoose').val(subcategory)
    Meteor.setTimeout ->
      $( "#gallery-items-thumbs" ).sortable({
        stop: (e, ui)->
          MainCtrl.galleryAdmin.reorderPics()
      })
    , 1000
  'click aside li .delete': (e)->
    clicked = $(e.target).closest('li')
    id = clicked.data('id')
    images = Gallery.findOne({'_id': id}).images
    order = parseInt clicked.data('order'), 10
    console.log images
    (new PNotify({
      title: 'Удалить целый альбом?',
      text: 'Все фотографии этого альбома будут удалены с хостинга',
      hide: false,
      addclass: 'aura-notify'
      confirm: {
        confirm: true
      },
      buttons: {
        closer: false,
        sticker: false
      },
      history: {
        history: false
      }
    })).get().on('pnotify.confirm', ->

      Meteor.call 'deletePics', images, (err, res)->
        if err

          Aura.notify 'Изображения не удалены:( Может и к лучшему))'

        else

          if res

            Gallery.remove id
            Aura.notify 'Альбом удален!'
            MainCtrl.hideLoader()
            $(e.target).closest('ul').find('li').first().trigger('click')

            Gallery.find({order: {$gt: order}}).fetch().forEach (album)->
              newOrder = album.order - 1
              id = album._id
              Gallery.update id, {$set: {order: newOrder}}

          else

            Aura.notify 'Изображения не удалены:( Ошибка на стороне сервера'

    ).on('pnotify.cancel', ->
      console.log 'deletion canceled'
    )


  'click aside .add-new': (e)->

    Gallery.find().fetch().forEach (album)->
      newOrder = album.order + 1
      console.log newOrder
      Gallery.update album._id, {$set: {order: newOrder}}

    Gallery.insert {
      order: 0,
      category: 'home',
      subcategory: 'cafe',
      images: [],
      title: 'Новый альбом'
    }, (id)->
      Meteor.setTimeout ->
        $(e.target).siblings('ul').find('li').first().trigger('click')
      , 300

  'keypress #albumName': (e)->
    Meteor.setTimeout ->
      id = $('#albumId').val()
      text = $(e.target).val()
      Gallery.update id, {$set: {'title': text}}, {reactive: false}
    , 200

  'change #categoryChoose': (e)->
    value = $(e.target).val()
    id = $('#albumId').val()
    Gallery.update id, {$set: {category: value}}
  'change #subcategoryChoose': (e)->
    value = $(e.target).val()
    id = $('#albumId').val()
    Gallery.update id, {$set: {subcategory: value}}
}

Meteor.setTimeout ->
  $('#gallery-albums-list').sortable({
    stop: (e, ui)->
      MainCtrl.galleryAdmin.reorderAlbums()
  })
  $('.auraModal').find('.list-wrap').empty()
  if $('.auraModal').find('.list-wrap').length > 0
    if Session.get('auraModalList') is 'initial'
      UI.insert(UI.renderWithData(Template.galleryList, Gallery.findOne()), $('.auraModal').find('.list-wrap').get(0))
    else
      UI.insert(UI.renderWithData(Template.galleryList, Gallery.findOne({'_id': Session.get('auraModalList')})), $('.auraModal').find('.list-wrap').get(0))
, 3000

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
        setTimeout ->
          MainCtrl.galleryAdmin.reorderPics()
        , 1000
    })
  , 1000




class @TemplatesRendered

  constructor: (@max, @callback)->
    console.log 'TRinit'

  count: 0

  loaded: ->

    console.log 'template loaded yo'

    @count++

    if @count >= @max

      console.log 'all templates loaded!'

      MainCtrl.svgLoader.update(2)

      @callback()


class @Loader

  constructor: (@assets, @callback)->

    @max = @assets.length

    @init()

  count: 0

  progress: (ins)->

    console.log 'файл' + ins + 'загружен! Ура'

    MainCtrl.svgLoader.update(1)

    @count++

    if @count >= @max

      Meteor.setTimeout =>
        $('.preloading').addClass('_loaded')
        @callback()
      , 600

  init: ->

    console.log @assets

    _.each @assets, (img)=>

      $('<img>').attr('src', 'http://d9bm0rz9duwg1.cloudfront.net/' + img).load =>

        console.log 'img loaded'

        @progress(img)




Deps.autorun ->

  if Session.get('pagesReady') is true

    MainCtrl.init()









