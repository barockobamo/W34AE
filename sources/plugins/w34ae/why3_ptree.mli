(*******************************************************************************)
(*                                                                             *)
(*   W34AE: A parser of Why3 logic for Alt-Ergo                                *)
(*                                                                             *)
(*   Copyright 2011-2017 OCamlPro SAS                                          *)
(*                                                                             *)
(*   All rights reserved.  This file is distributed under the terms of         *)
(*   the GNU Lesser General Public License version 2.1, with the               *)
(*   special exception on linking described in the file LICENSE.               *)
(*                                                                             *)
(*******************************************************************************)

open Big_int

type ind_sign = Ind | Coind

type prop_kind =
  | Plemma    
  | Paxiom    
  | Pgoal     
  | Pskip     

type loc = Why3_loc.position
type integer_constant = Why3_number.integer_constant
type real_constant = Why3_number.real_constant
type constant = Why3_number.constant
type w3idlabel = { lab_string : string }                  
type label = Lstr of w3idlabel | Lpos of Why3_loc.position
type quant = Tforall | Texists | Tlambda
type binop = Tand | Tand_asym | Tor | Tor_asym | Timplies | Tiff | Tby | Tso
type unop = Tnot
type ident = { id_str : string; id_lab : label list; id_loc : loc; }
type qualid = Qident of ident | Qdot of qualid * ident
type opacity = bool
type pty = Parsed.ppure_type
   (* PTtyvar of ident * opacity
  | PTtyapp of qualid * pty list
  | PTtuple of pty list
  | PTarrow of pty * pty
  | PTparen of pty*)
type ghost = bool
type binder = loc * ident option * Parsed.ppure_type option
type param = loc * ident option * Parsed.ppure_type 
type pattern = { pat_desc : pat_desc; pat_loc : loc; }
and pat_desc =
    Pwild
  | Pvar of ident
  | Papp of qualid * pattern list
  | Prec of (qualid * pattern) list
  | Ptuple of pattern list
  | Por of pattern * pattern
  | Pas of pattern * ident
  | Pcast of pattern * pty
type term = { term_desc : term_desc; term_loc : loc; }
and term_desc =
    Ttrue
  | Tfalse
  | Tconst of constant
  | Tident of qualid
  | Tidapp of qualid * term list
  | Tapply of term * term
  | Tinfix of term * ident * term
  | Tinnfix of term * ident * term
  | Tbinop of term * binop * term
  | Tunop of unop * term
  | Tif of term * term * term
  | Tquant of quant * binder list * term list list * term
  | Tnamed of label * term
  | Tlet of ident * term * term
  | Tmatch of term * (pattern * term) list
  | Tcast of term * pty
  | Ttuple of term list
  | Trecord of (qualid * term) list
  | Tupdate of term * (qualid * term) list
type use = { use_theory : qualid; use_import : (bool * string) option; }
type clone_subst =
    CSns of loc * qualid option * qualid option
  | CStsym of loc * qualid * ident list * pty
  | CSfsym of loc * qualid * qualid
  | CSpsym of loc * qualid * qualid
  | CSvsym of loc * qualid * qualid
  | CSlemma of loc * qualid
  | CSgoal of loc * qualid

type type_def =
    TDabstract
  | TDalias of pty
  | TDalgebraic of (loc * ident * param list) list
  | TDrange of big_int * big_int
  | TDfloat of int * int
type visibility = Public | Private | Abstract
type invariant = term list
type type_decl = {
  td_loc : loc;
  td_ident : ident;
  td_params : ident list;
  td_model : bool;
  td_vis : visibility;
  td_def : type_def;
  td_inv : invariant;
}
type logic_decl = {
  ld_loc : loc;
  ld_ident : ident;
  ld_params : param list;
  ld_type : pty option;
  ld_def : term option;
}
                  
type use_clone = use * clone_subst list option
type decl =
    Dtype of type_decl list
  | Dlogic of logic_decl list
  | Dprop of prop_kind * ident * term
