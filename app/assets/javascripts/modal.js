// summernote editor
$('#message-text').summernote({
toolbar: [
  // [groupName, [list of button]]
  ['style', ['bold', 'italic', 'underline', 'clear']],
  ['font', ['strikethrough', 'superscript', 'subscript']],
  ['fontsize', ['fontsize']],
  ['color', ['color']],
  ['para', ['ul', 'ol', 'paragraph']],
  ['height', ['height']],
  ],
  placeholder: 'Write here...'
});

$('#read-message-text').summernote({
toolbar: [
  // [groupName, [list of button]]
  ['style', ['bold', 'italic', 'underline', 'clear']],
  ['font', ['strikethrough', 'superscript', 'subscript']],
  ['fontsize', ['fontsize']],
  ['color', ['color']],
  ['para', ['ul', 'ol', 'paragraph']],
  ['height', ['height']]
  ]
});
$("#read-message-modal .note-editable.panel-body").attr("contenteditable","false");

var REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' + '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)';

var $select = $('#select-to').selectize({
  persist: false,
  maxItems: null,
  valueField: 'id',
  labelField: 'name',
  searchField: ['name', 'email'],
  render: {
    item: function(item, escape) {
      return '<div>' +
      (item.name ? '<span class="name">' + escape(item.name) + '</span>' : '') +
      (item.email ? '<span class="email">' + escape(item.email) + '</span>' : '') +
      '</div>';
    },
    option: function(item, escape) {
      var label = item.name || item.email;
      var caption = item.name ? item.email : null;
      return '<div>' +
      '<span class="label">' + escape(label) + '</span>' +
      (caption ? '<span class="caption">' + escape(caption) + '</span>' : '') +
      '</div>';
    }
  },
  createFilter: function(input) {
    var match, regex;

    // email@address.com
    regex = new RegExp('^' + REGEX_EMAIL + '$', 'i');
    match = input.match(regex);
    if (match) return !this.options.hasOwnProperty(match[0]);

    // name <email@address.com>
    regex = new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i');
    match = input.match(regex);
    if (match) return !this.options.hasOwnProperty(match[2]);

    return false;
  },
  create: function(input) {
    if ((new RegExp('^' + REGEX_EMAIL + '$', 'i')).test(input)) {
      return {email: input};
    }
    var match = input.match(new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i'));
    if (match) {
      return {
        email : match[2],
        name  : $.trim(match[1])
      };
    }
    alert('Invalid email address.');
    return false;
  }
});

var selectize = $select[0].selectize;
