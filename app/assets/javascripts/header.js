$(document).ready(function() {
	var link = $('.account');
	var menu = $('.accountMenu');
	link.live('mouseover', function() {
		menu.show();
		return false;
	})
	menu.live('mouseover', function() {
		return false;
	})
	$(document).live('mouseover', function() {
		menu.hide();
	})
})