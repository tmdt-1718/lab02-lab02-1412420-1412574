class window.Modal 
  @initPopUp: () -> 
    $('#message-text').summernote
      toolbar: [
        [
          'style'
          [
            'bold'
            'italic'
            'underline'
            'clear'
          ]
        ]
        [
          'font'
          [
            'strikethrough'
            'superscript'
            'subscript'
          ]
        ]
        [
          'fontsize'
          [ 'fontsize' ]
        ]
        [
          'color'
          [ 'color' ]
        ]
        [
          'para'
          [
            'ul'
            'ol'
            'paragraph'
          ]
        ]
        [
          'height'
          [ 'height' ]
        ]
      ],
      placeholder: 'Write here...'
    $('#read-message-text').summernote toolbar: [
      [
        'style'
        [
          'bold'
          'italic'
          'underline'
          'clear'
        ]
      ]
      [
        'font'
        [
          'strikethrough'
          'superscript'
          'subscript'
        ]
      ]
      [
        'fontsize'
        [ 'fontsize' ]
      ]
      [
        'color'
        [ 'color' ]
      ]
      [
        'para'
        [
          'ul'
          'ol'
          'paragraph'
        ]
      ]
      [
        'height'
        [ 'height' ]
      ]
    ]
    $('#read-message-modal .note-editable.panel-body').attr 'contenteditable', 'false'

    REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' + '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)'
    $select = $('#select-to').selectize(
      persist: false
      maxItems: null
      valueField: 'id'
      labelField: 'name'
      searchField: [
        'name'
        'email'
      ]
      options: [
      ],
      render:
        item: (item, escape) ->
          '<div>' + (if item.name then '<span class="name"><b>' + escape(item.name) + '</b></span> ' else '') + (if item.email then '<span class="email">' + escape(item.email) + '</span>' else '') + '</div>'
        option: (item, escape) ->
          label = item.name or item.email
          caption = if item.name then item.email else null
          '<div>' + '<span class="label">' + escape(label) + '</span>' + (if caption then '<span class="caption">' + escape(caption) + '</span>' else '') + '</div>'
      createFilter: (input) ->
        match = undefined
        regex = undefined
        # email@address.com
        regex = new RegExp('^' + REGEX_EMAIL + '$', 'i')
        match = input.match(regex)
        if match
          return !@options.hasOwnProperty(match[0])
        # name <email@address.com>
        regex = new RegExp('^([^<]*)<' + REGEX_EMAIL + '>$', 'i')
        match = input.match(regex)
        if match
          return !@options.hasOwnProperty(match[2])
        false
      create: (input) ->
        if new RegExp('^' + REGEX_EMAIL + '$', 'i').test(input)
          return { email: input }
        match = input.match(new RegExp('^([^<]*)<' + REGEX_EMAIL + '>$', 'i'))
        if match
          return {
            email: match[2]
            name: $.trim(match[1])
          }
        alert 'Invalid email address.'
        false
    )
    window.selectize = $select[0].selectize