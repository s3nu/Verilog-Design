module voting_rule(w,n,o,a,b,c,d);
    input w,n,o;
    output a,b,c,d;
    assign a = w&n&o;
    assign b = ~w&~n&o | ~w&n&o | w&~n&o | w&n&~o;
    assign c = ~w&n&~o | ~w&n&o | w&~n&~o | w&~n&o;
    assign d = ~w&n&~o | ~w&n&o | w&n&~o | w&n&o;
endmodule // end voting_rule
