$(document).ready(function() {
	var link = $('.account');
	var menu = $('.accountMenu');
	$(document).on('mouseover', '.account', function() {
		menu.show();
		return false;
	});
	$(document).on('mouseover', '.accountMenu', function() {
		return false;
	});
	$(document).on('mouseover', function() {
		menu.hide();
	});
});