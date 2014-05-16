if Meteor.isServer

  if Meteor.users.find().count() is 0
    user = Accounts.createUser {
      username: 'root'
      email: 'albertkai@me.com'
      password: '12345678'
      profile: {
        name: 'Альберт',
        surname: 'Кайгородов'
      }
    }
    Roles.addUsersToRoles(user, ['root','admin'])


  Meteor.startup ->

    if Pages.find().count() is 0

      console.log 'hey'
      Pages.insert {
        name: 'top'
        image1: 'top_slide_1.jpg'
        image2: 'top_slide_2.jpg'
        image3: 'top_slide_3.jpg'
        text1: 'МЫ ИСПОЛЬЗУЕМ ТОЛЬКО<br/>СОВРЕМЕННЫЕ МАТЕРИАЛЫ И<br/>АКТУАЛЬНЫЕ ТРЕНДЫ В<br/>ДИЗАЙНЕ МЕБЕЛИ'
        text2: 'МЫ ИСПОЛЬЗУЕМ ТОЛЬКО<br/>СОВРЕМЕННЫЕ МАТЕРИАЛЫ И<br/>АКТУАЛЬНЫЕ ТРЕНДЫ В<br/>ДИЗАЙНЕ МЕБЕЛИ'
        text3: 'МЫ ИСПОЛЬЗУЕМ ТОЛЬКО<br/>СОВРЕМЕННЫЕ МАТЕРИАЛЫ И<br/>АКТУАЛЬНЫЕ ТРЕНДЫ В<br/>ДИЗАЙНЕ МЕБЕЛИ'
      }

      Pages.insert {
        name: 'service'
        shortDesc1: 'Мы производим красивую и удобную мебель из качественных материалов и с актуальным дизайном'
        shortDesc2: 'Мы производим красивую и удобную мебель из качественных материалов и с актуальным дизайном'
        shortDesc3: 'Мы производим красивую и удобную мебель из качественных материалов и с актуальным дизайном'
        descHome: '<h2><span>Мебель для</span><br/><span>ДОМА</span></h2>
                            <ol>
                                <li>
                                    <h4>Измеряем стены</h4>
                                    <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                </li>
                                <li>
                                    <h4>Измеряем стены</h4>
                                    <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                </li>
                                <li>
                                    <h4>Измеряем стены</h4>
                                    <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                </li>
                            </ol>'
        descOffice: '<h2><span>Мебель для</span><br/><span>ДОМА</span></h2>
                                  <ol>
                                      <li>
                                          <h4>Измеряем стены</h4>
                                          <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                      </li>
                                      <li>
                                          <h4>Измеряем стены</h4>
                                          <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                      </li>
                                      <li>
                                          <h4>Измеряем стены</h4>
                                          <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                      </li>
                                  </ol>'
        descCommerce: '<h2><span>Мебель для</span><br/><span>ДОМА</span></h2>
                                  <ol>
                                      <li>
                                          <h4>Измеряем стены</h4>
                                          <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                      </li>
                                      <li>
                                          <h4>Измеряем стены</h4>
                                          <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                      </li>
                                      <li>
                                          <h4>Измеряем стены</h4>
                                          <p>Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>
                                      </li>
                                  </ol>'
      }


      Pages.insert {
        name: 'capabilities',
        'tltp1': '<div></div>
                            <h4>Консультация</h4>
                            <p>Измеряем стены
                                Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.

                                2 Придумываем план
                                Теперь сядьте вдвоем с мужем/женой и обсудите важнейшие вопросы: a. много ли кухонной мебели  вы будете покупать; b. как она будет стоять (по одной или двум сторонам, углом или буквой П); c. какие бытовые приборы (и оборудование) вам нужны. Может быть, старая духовка или мойка еще послужит?

                                3 Рисуем проект
                                Возьмите кусок миллиметровки или </p>'
        'tltp2': '<div></div>
                                    <h4>Консультация</h4>
                                    <p>Измеряем стены
                                        Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>'

        'tltp3': '<div></div>
                                            <h4>Консультация</h4>
                                            <p>Измеряем стены
                                                Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>'

        'tltp4': '<div></div>
                                            <h4>Консультация</h4>
                                            <p>Измеряем стены
                                                Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>'

        'tltp5': '<div></div>
                                            <h4>Консультация</h4>
                                            <p>Измеряем стены
                                                Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.</p>'

        'desc1': 'Окра́ска — свойство предметов отражать, переизлучать и рассеивать свет, определяющее их визуальное восприятие в определённых условиях — ощущаемый человеком цвет.

                                        Термин окраска не является синонимом слова цвет; он имеет более специальный смысл, нежели понятие оттенок. Часто слово окраска используется применительно к объектам, цвет которых изменчив (Окраска минералов), в случаях, когда цвет имеет ключевое значение (Покровительственная окраска, Предупреждающая окраска и др.). В технике термин широко используется в отношении объектов, специально окрашенных в определённые цвета (Опознавательная окраска, Шкала гипсометрической окраски). Окраска может дополнительно характеризовать объект: например, окраска и цветность воды — важные признаки, используемые при оценке её качества.
                                        Термин окраска используется также для определения собственно процесса окрашивания, как синоним слов крашение, покраска, например, окраска микроорганизмов.'

        'desc2': 'Окра́ска — свойство предметов отражать, переизлучать и рассеивать свет, определяющее их визуальное восприятие в определённых условиях — ощущаемый человеком цвет.

                                                Термин окраска не является синонимом слова цвет; он имеет более специальный смысл, нежели понятие оттенок. Часто слово окраска используется применительно к объектам, цвет которых изменчив (Окраска минералов), в случаях, когда цвет имеет ключевое значение (Покровительственная окраска, Предупреждающая окраска и др.). В технике термин широко используется в отношении объектов, специально окрашенных в определённые цвета (Опознавательная окраска, Шкала гипсометрической окраски). Окраска может дополнительно характеризовать объект: например, окраска и цветность воды — важные признаки, используемые при оценке её качества.
                                                Термин окраска используется также для определения собственно процесса окрашивания, как синоним слов крашение, покраска, например, окраска микроорганизмов.'

        'desc3': 'Окра́ска — свойство предметов отражать, переизлучать и рассеивать свет, определяющее их визуальное восприятие в определённых условиях — ощущаемый человеком цвет.

                                                Термин окраска не является синонимом слова цвет; он имеет более специальный смысл, нежели понятие оттенок. Часто слово окраска используется применительно к объектам, цвет которых изменчив (Окраска минералов), в случаях, когда цвет имеет ключевое значение (Покровительственная окраска, Предупреждающая окраска и др.). В технике термин широко используется в отношении объектов, специально окрашенных в определённые цвета (Опознавательная окраска, Шкала гипсометрической окраски). Окраска может дополнительно характеризовать объект: например, окраска и цветность воды — важные признаки, используемые при оценке её качества.
                                                Термин окраска используется также для определения собственно процесса окрашивания, как синоним слов крашение, покраска, например, окраска микроорганизмов.'

        'desc4': 'Окра́ска — свойство предметов отражать, переизлучать и рассеивать свет, определяющее их визуальное восприятие в определённых условиях — ощущаемый человеком цвет.

                                                Термин окраска не является синонимом слова цвет; он имеет более специальный смысл, нежели понятие оттенок. Часто слово окраска используется применительно к объектам, цвет которых изменчив (Окраска минералов), в случаях, когда цвет имеет ключевое значение (Покровительственная окраска, Предупреждающая окраска и др.). В технике термин широко используется в отношении объектов, специально окрашенных в определённые цвета (Опознавательная окраска, Шкала гипсометрической окраски). Окраска может дополнительно характеризовать объект: например, окраска и цветность воды — важные признаки, используемые при оценке её качества.
                                                Термин окраска используется также для определения собственно процесса окрашивания, как синоним слов крашение, покраска, например, окраска микроорганизмов.'

        'desc5': 'Окра́ска — свойство предметов отражать, переизлучать и рассеивать свет, определяющее их визуальное восприятие в определённых условиях — ощущаемый человеком цвет.

                                                Термин окраска не является синонимом слова цвет; он имеет более специальный смысл, нежели понятие оттенок. Часто слово окраска используется применительно к объектам, цвет которых изменчив (Окраска минералов), в случаях, когда цвет имеет ключевое значение (Покровительственная окраска, Предупреждающая окраска и др.). В технике термин широко используется в отношении объектов, специально окрашенных в определённые цвета (Опознавательная окраска, Шкала гипсометрической окраски). Окраска может дополнительно характеризовать объект: например, окраска и цветность воды — важные признаки, используемые при оценке её качества.
                                                Термин окраска используется также для определения собственно процесса окрашивания, как синоним слов крашение, покраска, например, окраска микроорганизмов.'

        'img1': 'consult.jpg'
        'img2': 'design_process.png'
        'img3': 'production.jpg'
        'img4': 'painting.jpg'
        'img5': 'install.jpg'

      }

      Pages.insert {
        name: 'contacts'
        phone: '<h3><i class="fa fa-phone"></i>Телефон</h3>
                            <p>+7-903-579-84-36</p><p>+7-962-965-15-01</p><span>Звоните нам с 10:00 до 20:00 семь дней в неделю</span>'
        email: '<h3><i class="fa fa-envelope"></i>Почта</h3>
                            <p>solominvik@mail.ru</p><span>в случае, если у вас есть готовый проект, отправьте его на этот адрес, и мы назовем вам примерную стоимость</span>'
        address: '<h3><i class="fa fa-map-marker"></i>Адрес</h3>
                            <p>Мытищи, ул. Веры Волошиной, 19, офис 320 </p><span>мы также можем встретиться в любом удобном вам месте</span>'
      }
