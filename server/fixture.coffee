
if Gallery.find().count() < 5

  Gallery.insert {
    'category': 'home'
    'subcategory': 'children'
    'images': ['DSC_0039', 'DSC_0040', 'DSC_0041']
    'main': 'DSC_0039'
    'title': 'Детская'
  }

  Gallery.insert {
    'category': 'commerce'
    'subcategory': 'shop'
    'images': ['DSC_0060', 'DSC_0061', 'DSC_0062']
    'main': 'DSC_0060'
    'title': 'Магазин'
  }

  Gallery.insert {
    'category': 'commerce'
    'subcategory': 'cafe'
    'images': ['DSC_3125', 'DSC_3136']
    'main': 'DSC_3125'
    'title': 'Кафе'
  }

  Gallery.insert {
    'category': 'home'
    'subcategory': 'cabinet'
    'images': ['IMAG0141', 'IMAG0143', 'IMAG0144', 'IMAG0145']
    'main': 'IMAG0141'
    'title': 'Кабинет'
  }


if News.find().count() < 4

  News.insert {
    category: 'action'
    title: 'Скидки для жителей ЖК "Слобода"'
    content: 'е» - сама сделаю
           7) На старом сайте в «Гиде гостя»«Окружение» была старая карта треугольника из 3 монастырей и «Золотой Горки» в середине. Можно её перенести? Для гармонии надо добавить 3 фото ещё 2 монастырей(очевидно. Жду фото от Андрея, так как именно эти монастыри он фотографировал).
            8) «Территория» - слева вылезли английские слова. Может сюда надо карту?
            9) На странице Veg-кафе нет названия вверху её.
           10) ОБРАТНАЯ СВЯЗЬ: непонятно как в «Отзывах» их оставлять? Нужно, чтобы была какая-то рамка, в которую писать информацию??? У крымчан справа всегда болтается рамка «Задать вопрос», например. Функционал шаблона не предусматривает этого. Можно только ролики с ютуба сюда прикреплять, или свой текст (отзывы, которые сами написали)
           11) Непонятно, как в «Событиях» их обозначать и как они будут выглядеть? (как обозначить, я знаю, а выглядеть будут так-же, как ауроконференция в августе)
          12) В «Блоге» который должен быть «Новостями» справ английские буквы.
    '
    date: 'Thu May 15 2014 15:32:13 GMT+0400 (MSK)'
  }

  News.insert {
    category: 'blog'
    title: 'Как выбрать кухню?'
    content: 'Измеряем стены
    Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.

    2 Придумываем план
    Теперь сядьте вдвоем с мужем/женой и обсудите важнейшие вопросы: a. много ли кухонной мебели  вы будете покупать; b. как она будет стоять (по одной или двум сторонам, углом или буквой П); c. какие бытовые приборы (и оборудование) вам нужны. Может быть, старая духовка или мойка еще послужит?

    3 Рисуем проект
    Возьмите кусок миллиметровки или хотя бы листочек в клетку. Начертите в масштабе вашу кухню и попробуйте расположить в ней мебель, варочную панель, мойку и пр. Имейте в виду: если есть проблема с квадратными метрами, надо по возможности задействовать углы.'
    date: 'Thu May 7 2014 15:32:13 GMT+0400 (MSK)'
  }

  News.insert {
    category: 'blog'
    title: 'Как мы добились такого качества покраски?'
    content: 'Измеряем стены
        Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.

        2 Придумываем план
        Теперь сядьте вдвоем с мужем/женой и обсудите важнейшие вопросы: a. много ли кухонной мебели  вы будете покупать; b. как она будет стоять (по одной или двум сторонам, углом или буквой П); c. какие бытовые приборы (и оборудование) вам нужны. Может быть, старая духовка или мойка еще послужит?'
    date: 'Thu May 5 2014 15:32:13 GMT+0400 (MSK)'
  }

  News.insert {
    category: 'action'
    title: 'Скидки в честь Дня Победы'
    content: 'Измеряем стены
                Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.

                2 Придумываем план
                Теперь сядьте вдвоем с мужем/женой и обсудите важнейшие вопросы: a. много ли кухонной мебели  вы будете покупать; b. как она будет стоять (по одной или двум сторонам, углом или буквой П); c. какие бытовые приборы (и оборудование) вам нужны. Может быть, старая духовка или мойка еще послужит?'
    date: 'Thu May 3 2014 15:32:13 GMT+0400 (MSK)'
  }

  News.insert {
    category: 'action'
    title: 'Мир, Труд, Май!!'
    content: 'Измеряем стены
                Главное – узнать точные размеры кухни. Не поленитесь и исследуйте с линейкой в руках каждый ее уголок. Измерьте всё: длину каждой стены, высоту потолков, расстояние между полом и подоконником и пр.

                2 Придумываем план
                Теперь сядьте вдвоем с мужем/женой и обсудите важнейшие вопросы: a. много ли кухонной мебели  вы будете покупать; b. как она будет стоять (по одной или двум сторонам, углом или буквой П); c. какие бытовые приборы (и оборудование) вам нужны. Может быть, старая духовка или мойка еще послужит?'
    date: 'Thu May 1 2014 15:32:13 GMT+0400 (MSK)'
  }
