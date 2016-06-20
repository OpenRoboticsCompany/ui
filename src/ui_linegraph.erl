-module(ui_linegraph).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).

-export([draw/3, animate/0]).

plot(Widget, [], _X, _Y, _Dx, _Dy, _Dm) ->
	Widget;

plot(Widget,[D|Ds],X,Y,Dx,Dy,Dm) ->
	W = ui:lineTo(Widget, round(X+Dx), round(Y + Dy*(D-Dm))),
	plot(W,Ds,X+Dx,Y,Dx,Dy,Dm);

plot(Widget,X,Y,Dx,Dy,Dm,{ { R, G, B, A }, [ D | Ds ]}) ->
	Wp = ui:path(Widget),
	Wc = ui:foreground(Wp,R,G,B,A),
	Wm = ui:moveTo(Wc,X,round(Y + Dy*(D - Dm))),
	plot(Wm,Ds,X,Y,Dx,Dy,Dm).
	

limits([], Min, Max ) ->
	{ Min, Max };
limits([ { _, Ds } | Rest ], Min, Max ) ->
	Dmin = lists:foldl(fun(A,B) -> min(A,B) end, Min, Ds),
	Dmax = lists:foldl(fun(A,B) -> max(A,B) end, Max, Ds),
	limits( Rest, Dmin, Dmax).
	

% data takes to form of a list of tuples:
%
%  [  { { r,g,b,a}, [ data ... ] }, ... ]

draw(Widget, {{ Rb,Gb,Bb,Ab }, S, R }, [ { _, D } | _  ] = Data) ->
	{ X, Y, W, H } = ui:extent(Widget),
	Graph = ui:path(Widget),
	Wc = ui:foreground(Graph,Rb,Gb,Bb,Ab),
	Wb = ui_graph:bounds(Wc,X,Y,W,H),
	Wh = ui_graph:hashes(Wb,X,Y,W,H,S,R),
	{ Dmin, Dmax } = limits(Data,0,0),
	Dx = W / length(D),
	Dy = H / (Dmax - Dmin),	
	Wp = lists:foldl(fun(Line,Wx) -> plot(Wx,X,Y,Dx,Dy,Dmin,Line) end, Wh, Data),
	ui:path(Wp).


animate(A,B,C) ->
	Widget = ui:widget(100,100,600,300),
	Wbg = ui:background(Widget,0,0,0,255),
	Wbl = ui:blank(Wbg),
	Wdrawn = draw(Wbl,{{255,255,255,255},30,5},[
		{ { 255,0,0,255}, A },
		{ { 0,255,0,255}, B },
		{ { 0,0, 255,255}, C }]),
	ui:draw(Wdrawn),
	receive
	after 100 ->
		[ _ | As ] = A,
		[ _ | Bs ] = B,
		[ _ | Cs ] = C,
		animate( As ++ [ rand:uniform(10)],
			Bs ++ [ rand:uniform(10) ],
			Cs ++ [ rand:uniform(10)])
	end.

animate() ->
	A = [ rand:uniform(10) || _X <- lists:seq(0,20) ],
	B = [ rand:uniform(10) || _X <- lists:seq(0,20) ],
	C = [ rand:uniform(10) || _X <- lists:seq(0,20) ],
	spawn(fun() -> animate(A,B,C) end).
