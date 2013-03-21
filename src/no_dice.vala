/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * main.c
 * Copyright (C) 2013 Adam and Monica Stark <llamadonica@gmail.com>
 * 
 * no-dice is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * no-dice is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;

public class Main : Object 
{

	/* 
	 * Uncomment this line when you are done testing and building a tarball
	 * or installing
	 */
	//const string UI_FILE = Config.PACKAGE_DATA_DIR + "/" + "no_dice.ui";
	const string UI_FILE = "src/no_dice.ui";

	/* ANJUTA: Widgets declaration for no_dice.ui - DO NOT REMOVE */


	public Main ()
	{

		try 
		{
			var builder = new Builder ();
			builder.add_from_file (UI_FILE);
			builder.connect_signals (this);

			var window    = builder.get_object ("window") as Window;
			var combo_box = builder.get_object ("combo-box-die-type") as ComboBoxText;
			/* ANJUTA: Widgets initialization for no_dice.ui - DO NOT REMOVE */
			combo_box.active_id = "d/d6";
			window.show_all ();
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}

	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		Gtk.main_quit();
	}
	
	[CCode (instance_pos = -1)]
	public void on_validate_number_entry (Editable edit, string new_text, int new_text_length, ref int position)
	{
		var return_text = new StringBuilder ();
		unichar current_char = '\0';
		for (int i = 0; i < new_text.length; i++) {
			if (new_text.valid_char (i)) {
				current_char = new_text.get_char (i);
				if (current_char.isdigit ()) {
					return_text.append_unichar (current_char);
				}
			}
		}
		SignalHandler.block_by_func (edit, (void*) Main.on_validate_number_entry, this);
		edit.insert_text (return_text.str, return_text.str.length, ref position);
		SignalHandler.unblock_by_func (edit, (void*) Main.on_validate_number_entry, this);
		Signal.stop_emission_by_name (edit,"insert_text");
	}
	
	[CCode (instance_pos = -1)]
	public void on_validate_plus_minus_number_entry (Editable edit, string new_text, int new_text_length, ref int position)
	{
		var return_text = new StringBuilder ();
		unichar current_char = '\0';
		for (int i = 0; i < new_text.length; i++) {
			if (new_text.valid_char (i)) {
				current_char = new_text.get_char (i);
				if (current_char.isdigit () || current_char == '+' || current_char == '-') {
					return_text.append_unichar (current_char);
				}
			}
		}
		SignalHandler.block_by_func (edit, (void*) Main.on_validate_number_entry, this);
		edit.insert_text (return_text.str, return_text.str.length, ref position);
		SignalHandler.unblock_by_func (edit, (void*) Main.on_validate_number_entry, this);
		Signal.stop_emission_by_name (edit,"insert_text");
	}

	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new Main ();

		Gtk.main ();
		
		return 0;
	}
}
