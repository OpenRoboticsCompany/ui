-module(ui).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).
-export([ lineTo/3, moveTo/3, fill/3, clear/3, foreground/5, background/5, draw/1 ]).

lineTo(Widget,X,Y) ->
	Widget ++ [ <<"l">>, X, Y ].
	
moveTo(Widget,X,Y) ->
	Widget ++ [ <<"m">>, X, Y ].

fill(Widget,W,H) ->
	Widget ++ [ <<"f">>, W, H ].

clear(Widget,W,H) ->
	Widget ++ [ <<"c">>, W, H ].

foreground(Widget,R,G,B,A) ->
	Widget ++ [ <<"fg">>, R, G, B, A ].
	
background(Widget,R,G,B,A) ->
	Widget ++ [ <<"bg">>, R, G, B, A ].
	
draw(Widget) ->
	urelay_room:broadcast(ui_room, ujson:encode(Widget)).
