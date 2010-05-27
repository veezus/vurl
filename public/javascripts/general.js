function mainmenu(){
$(" #nav ul ul ").css({display: "none"}); // Opera Fix
$(" #nav ul li").hover(function(){
		$(this).find('ul:first').css({visibility: "visible",display: "none"}).show(300);
		},function(){
		$(this).find('ul:first').css({visibility: "hidden"});
		});
	 $('#submitform').ajaxForm({
			target: '#error',
			success: function() {
			$('#error').animate({ opacity: 1 }, 400);
			}
		});
}    
 
 $(document).ready(function(){					
	mainmenu();	
	$('#preloader').css("display","block");
	function preloader(){
                document.getElementById("preloader").style.display = "none";
        }//preloader
        window.onload = preloader;
	//Preserves the mouse-over on top-level menu elements when hovering over children
    $('.portfolio-thumb a').lightBox();
	$("#nav ul li ul").each(function(i){
      $(this).hover(function(){
        $(this).parent().find("a").slice(0,1).addClass("active");
      },function(){
        $(this).parent().find("a").slice(0,1).removeClass("active");
      });
	  	$('.portfolio-thumb img').hover(function() { //mouse in
		$(this).animate({ opacity: 0.5 }, 100);
	}, function() { //mouse out
		$(this).animate({ opacity: 1 }, 500);
	});
    });
	$('.options ul li a').click(function() {
		 $(this).css('outline','none'); 								  
		$('.options ul li.active').removeClass('active');
		$(this).parent().addClass('active');
		
		var filterVal = $(this).text().toLowerCase().replace(' ','-');
				
		if(filterVal == 'all') {
			$('li.portfolio-item.hidden').fadeIn('slow').removeClass('hidden');
		} else {
			$('li.portfolio-item').each(function() {
				if(!$(this).hasClass(filterVal)) {
					$(this).fadeOut('slow').addClass('hidden');
				} else {
					$(this).fadeIn('slow').removeClass('hidden');
				}
			});
		}
		
		return false;
	});
});
 	Cufon.replace('#leftcolumn h2',{
		textShadow: 'white 1px 1px'
});	
	Cufon.replace('.header h2',{
		textShadow: 'white 1px 1px'
});	
		Cufon.replace('.header3 h2',{
		textShadow: '#3c67a6 1px 1px'
});	
				Cufon.replace('#smallheader2 h2',{
		textShadow: '#3c67a6 1px 1px'
});	
	Cufon.replace('h3',{
		textShadow: '#fff 1px 1px'
});	