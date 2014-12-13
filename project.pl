:- consult('makeBoard.pl').
:- consult('printBoard.pl').
:- consult('replace.pl').
:- consult('numCells.pl').
:- consult('makeMove.pl').
:- consult('nearPieces.pl').
:- consult('input.pl').
:- consult('artificial.pl').

start :-
	use_module( library( lists ) ),
	makeBoard( B, S ),
	printSel( B, S, 5, 5 ).

%Initialize the game.
startGame( Size ) :-
	Size > 1,
	makeBoard( StartBoard, Spaces, Size ),
	get_gamemode( Mode ), %1 = Human vs Human, 2 = Human vs PC, 3 = PC vs PC.
	(	(Mode is 1) %If we picked Human vs Human:
	->	(Player1 = read_move, Player2 = read_move, %Set both players as reading their input from the user.
		write( 'Player O (2) may now edit the Board at will.' ), nl,
		edit_board( StartBoard, Spaces, Board ))
	;	%Otherwise...
		Board = StartBoard, %No editing happens in any other mode.
		((	(Mode is 2) %If we picked Human vs PC:
		->	Player1 = read_move %Set the first Player as reading the input from the user.
		;	(write( 'Select Computer difficulty.' ), nl,
			get_difficulty( PC1 ), %Otherwise, at this point Mode *has* to be 3, since it can only be 1, 2 or 3, and we get the difficulty for the first PC.
			(	(PC1 is 1) %If the 'Easy' version was picked:
			->	Player1 = computer_easy %Then the PC will be in 'easy mode'.
			;	Player1 = computer_hard %Otherwise, it will be in 'hard mode'.
			))
		), %Regardless of the mode being 2 or 3, we *do* have an opponent Computer which we need to get the difficulty for as well.
		write( 'Select Opponent Computer difficulty.' ), nl,
		get_difficulty( PC2 ), %So we get it, and...
		(	(PC2 is 1) %If 'Easy':
		->	Player2 = computer_easy %Then 'easy mode'.
		;	Player2 = computer_hard %Otherwise 'hard mode'.
		))
	),
	write( 'Initial Board:' ), nl,
	printBoard( Board, Spaces ), nl, nl, %Ensure that we can see the initial Board.
	playGame( Board, Spaces, 1, Player1, Player2 ), !. %Start the game with the Crosses (X).

startGame( _ ) :-
	write( '[ERROR] The Board Size needs to be bigger than 1.' ), nl.

startGame :-
	startGame( 5 ).

%Main game loop.
playGame( Board, Spaces, Piece, Player1, Player2 ) :-
	NPiece is 2-Piece+1, %Piece=1 -> 2, Piece=2 -> 1.
	playerMoves( Board, Piece, Valid ), %Check if the current Player can make any move.
	(	(Valid is 0) %If not...
	->	translate( Piece, Player ), translate( NPiece, Opponent ), printBoard( Board, Spaces ), %End the game.
		nl, nl, write( 'Player ' ), write( Player ), write( ' can\'t make any more moves! Player ' ), write( Opponent ), write( ' wins! ' ), nl
	;	%Otherwise, continue.
		(	(Piece is 1) %Check if we're Player1.
		->	G =.. [Player1, Board, Spaces, ResultBoard, Piece ] %Take the turn as Player1 if so.
		;	G =.. [Player2, Board, Spaces, ResultBoard, Piece ] %Otherwise take the turn as Player2.
		),
		G, %Actually execute the function.
		playGame( ResultBoard, Spaces, NPiece, Player1, Player2 )
	).
