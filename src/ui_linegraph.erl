-module(ui_linegraph).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).

-export([draw/7]).


bars(Widget,X,Y,W,H) ->
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

plot(Widget, [], _X, _Y, _Dx, _Dy, _Dm) ->
	Widget;

plot(Widget,[D|Ds],X,Y,Dx,Dy,Dm) ->
	W = ui:lineTo(Widget, round(X+Dx), round(Y + Dy*(D-Dm))),
	plot(W,Ds,X+Dx,Y,Dx,Dy,Dm).

draw(X,Y,W,H,S,R,[ D | Ds ] = Data) ->
	Wb = bars([],X,Y,W,H),
	Wh = hashes(Wb,X,Y,W,H,S,R),
	Dx = W / length(Data),
	Dmin = lists:foldl(fun(A,B) -> min(A,B) end, D, Ds ), 
	Dmax = lists:foldl(fun(A,B) -> max(A,B) end, D, Ds ), 
	Dy = H / (Dmax - Dmin),	
	Ws = ui:moveTo(Wh,X,Y + round(Dy*(D - Dmin))),
	plot(Ws, Ds,X,Y,Dx,Dy,Dmin).
	

