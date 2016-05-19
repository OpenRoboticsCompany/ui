-module(ui_graph).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).
-export([ bounds/5, hashes/7 ]).

bounds(Widget,X,Y,W,H) ->
	A = ui:moveTo(Widget,X,Y),
	B = ui:lineTo(A,X,Y+H),
	C = ui:moveTo(B,X,Y),
	ui:lineTo(C,X+W,Y).

vhash(Widget,X,Y,Rise) ->
	A = ui:moveTo(Widget,X,Y),
	ui:lineTo(A,X,Y+Rise).

hhash(Widget,X,Y,Rise) ->
	A = ui:moveTo(Widget,X,Y),
	ui:lineTo(A,X+Rise,Y).

hashseq(Widget,_X,[],_Rise) ->
	Widget;

hashseq(Widget,[],_Y,_Rise) ->
	Widget;

hashseq(Widget,[X|Xs],Y,Rise) when is_integer(Y) ->
	W = vhash(Widget,X,Y,Rise),
	hashseq(W,Xs,Y,Rise);

hashseq(Widget,X,[Y|Ys],Rise) when is_integer(X) ->
	W = hhash(Widget,X,Y,Rise),
	hashseq(W,X,Ys,Rise).

hashes(Widget,X,Y,W,H,Stride,Rise) ->
	Xs = lists:seq(X,X+W,Stride),		
	Ys = lists:seq(Y,Y+H,Stride),
	Wh = hashseq(Widget,Xs,Y,Rise),
	hashseq(Wh,X,Ys,Rise).


