// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function remove_fields(link) {  
  $(link).previous("input[type=hidden]").value = "1";  
  $(link).up(".nested_fields").hide();  
}

function add_fields(link, association, content) {  
  var new_id = new Date().getTime();  
  var regexp = new RegExp("new_" + association, "g");  
  $(link).up().insert({  
    before: content.replace(regexp, new_id)  
  });  
}

function convert_hour(hour_string) {
  if (hour_string.substring(0,1) == 0) {
    hour_string = hour_string.substring(1);
  }
  var mh = parseInt(hour_string)
  if (!isNaN(mh)) {
    var nh = mh % 12
    if (nh == 0) { nh = 12 }
    if (mh < 12) {
      nh = nh + 'am'
    } else {
      nh = nh + 'pm'
    }
    return nh
  }
  return hour_string
}