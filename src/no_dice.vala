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

public errordomain ParseError {
	NO_PARSE
}

public class Die {
	public int const_or_number;
	public int sides;
	public bool is_fudge;
	public Die(int number, int sides) {
		this.const_or_number = number;
		this.sides = sides;
		this.is_fudge = false;
	}
	public Die.fudge(int number) {
		this.const_or_number = number;
		this.sides = 1;
		this.is_fudge = true;
	}
	public Die.constant (int value) {
		this.const_or_number = value;
		this.sides = 0;
		this.is_fudge = false;
	}
}

public class Main : Object 
{

	/* 
	 * Uncomment this line when you are done testing and building a tarball
	 * or installing
	 */
#if MINGW_BUILD
	const string UI_FILE   =  Config.PACKAGE_NAME + Path.DIR_SEPARATOR_S +
		"ui" + Path.DIR_SEPARATOR_S + "no_dice.ui";
	const string ICON_FILE =  Config.PACKAGE_NAME + Path.DIR_SEPARATOR_S +
		"ui" + Path.DIR_SEPARATOR_S + "no_dice.png";
#else
	const string UI_FILE = Config.PACKAGE_DATA_DIR + Path.DIR_SEPARATOR_S + "ui" + Path.DIR_SEPARATOR_S + "no_dice.ui";
#endif
	// const string UI_FILE = "src/no_dice.ui";

	/* ANJUTA: Widgets declaration for no_dice.ui - DO NOT REMOVE */

	private int number_of_dice = 1;
	private int adjustment = 0;
	private List<Die?> dice ;
	private string last_manual_entry = "1d";
	private int skill_level = 1;
	
	private RadioButton radio_button_pick_dice;
	private RadioButton radio_button_enter_dice;
	private RadioButton radio_button_skill;
	private Label       result_label;
    private ComboBoxText combo_box_die_type;
    private AboutDialog about_dialog;

	public Main ()
	{

		try 
		{
			var builder = new Builder ();
			builder.add_from_file (path_from_resource(UI_FILE));
			builder.connect_signals (this);

			var window    = builder.get_object ("window") as Window;
			radio_button_enter_dice = builder.get_object ("radio-button-enter-dice") as RadioButton;
			radio_button_pick_dice = builder.get_object ("radio-button-pick-dice") as RadioButton;
			radio_button_skill = builder.get_object ("radio-button-skill") as RadioButton;
			result_label = builder.get_object ("result-label") as Label;
            combo_box_die_type = builder.get_object ("combo-box-die-type") as ComboBoxText;
            about_dialog = builder.get_object ("about-dialog") as AboutDialog;
            
			/* ANJUTA: Widgets initialization for no_dice.ui - DO NOT REMOVE */
#if MINGW_BUILD
			var logo = new Gdk.Pixbuf.from_file (path_from_resource(ICON_FILE));
			window.icon       = logo;
			about_dialog.logo = logo;
			
			var provider      = CssProvider.get_named ("gtk-win32", "xp");
			apply_css (window, provider);
			StyleContext.reset_widgets (Gdk.Screen.get_default());
#endif
			combo_box_die_type.active_id = "d/d6";
			this.dice = new List<Die> ();
			this.dice.append (new Die(1,6));
			window.show_all ();
            
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}

	public static string? path_from_resource(string resource) {
#if MINGW_BUILD
		var    paths = Environment.get_system_data_dirs ();
		foreach (string path in paths) {
			var resultant_path = Path.build_filename(path, resource, null);
			
			if (FileUtils.test (resultant_path, FileTest.EXISTS)) {
				return resultant_path;
			}
		}
		return null;
#else
		return resource;
#endif
	}

	public static void apply_css (Widget w, CssProvider css) {
		w.get_style_context().add_provider(css, uint.MAX);
		if (w is Container) {
			(w as Container).forall((subwidget) => 
				{
					apply_css (subwidget, css);
				});
		}
	}

	[CCode (instance_pos = -1)]
	public void on_activate_roll (Gtk.Action roll) {
		string result = "";
		if (radio_button_skill.active) {
			int margin; bool critical;
			result = roll_skill_die (this.skill_level,out critical,out margin);
		}
		if (radio_button_enter_dice.active) {
			result = roll_multi_die_set (this.dice);
		}
        if (radio_button_pick_dice.active) {
            int sides = 1;
            bool is_fudge = false;
            Die die;
            switch (combo_box_die_type.active_id) {
                case "d2":
                    sides = 2;
                    break;
                case "d4":
                    sides = 4;
                    break;
                case "d/d6":
                    sides = 6;
                    break;
                case "d8":
                    sides = 8;
                    break;
                case "d12":
                    sides = 12;
                    break;
                case "d20":
                    sides = 20;
                    break;
                case "d100":
                    sides = 100;
                    break;
                case "dF":
                    is_fudge = true;
                    break;
            }
            if (is_fudge) {
                die = new Die.fudge (number_of_dice);
            } else {
                die = new Die (number_of_dice, sides);
            }
            result = roll_one_die_set (die, adjustment);
        }
		result_label.label = result;
		
	}

	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		Gtk.main_quit();
	}

	[CCode (instance_pos = -1)]
    public void on_activate_about (Widget button)
    {
        this.about_dialog.run ();
        this.about_dialog.hide ();
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
	public bool on_blur_number_of_dice (Entry edit, DirectionType dir)
	{
		var return_value = int.parse (edit.text);
		if (return_value < 1) {
			return_value = 1;
			edit.text = "1";
		}
		this.number_of_dice = return_value;
		return false;
	}

	
	[CCode (instance_pos = -1)]
	public bool on_blur_skill_level (Entry edit, DirectionType dir)
	{
		var return_value = int.parse (edit.text);
		if (return_value < 1) {
			return_value = 0;
			edit.text = "0";
		}
		this.skill_level = return_value;
		return false;
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
		SignalHandler.block_by_func (edit, (void*) Main.on_validate_plus_minus_number_entry, this);
		edit.insert_text (return_text.str, return_text.str.length, ref position);
		SignalHandler.unblock_by_func (edit, (void*) Main.on_validate_plus_minus_number_entry, this);
		Signal.stop_emission_by_name (edit,"insert_text");
	}
    
	[CCode (instance_pos = -1)]
	public bool on_blur_plus_minus_number_entry (Entry edit, DirectionType dir) 
	{
		this.adjustment = int.parse (edit.text);
		if (this.adjustment == 0)
		{
			edit.text = "";
		}
		else if (this.adjustment > 0)
		{
			edit.text = "+%d".printf(this.adjustment);
		}
		else
		{
			edit.text = "%d".printf(this.adjustment);
		}
		return false;
	}

	[CCode (instance_pos = -1)]
	public bool on_blur_manual_dice_entry (Entry edit, DirectionType dir) 
	{
		string working_copy = edit.text;
		try {
			var dice = parse_dice (ref working_copy);
			this.last_manual_entry = edit.text;
			this.dice = new List<Die> ();
                foreach (Die die in dice) {
                    this.dice.append (die);
                }
		} catch (ParseError err) {
			stderr.printf ("ParseError: Expected %s\n", err.message);
			edit.text = this.last_manual_entry;
		}
		return false;
	}

	public static void parse_digit (ref string p, StringBuilder output) throws ParseError
	{
		var ch = p.get_char ();
		if (ch.isdigit()) {
			output.append_unichar (ch);
			p = p.next_char ();
		} else {
			throw new ParseError.NO_PARSE("digit");
		}
	}

	public static int parse_integer (ref string p) throws ParseError
	{
		var output = new StringBuilder();
		bool is_negative;
		try {
			parse_digit (ref p,output);
			is_negative = false;
		} catch (ParseError err) {
			var ch = p.get_char ();
			if (ch == '-') {
				output.append_unichar (ch);
				p = p.next_char ();
				is_negative = true;
			} else {
				throw new ParseError.NO_PARSE(err.message + " or '-'");
			}
		}
		if (is_negative) {
			parse_digit (ref p,output);
		}
		bool is_valid = true;
		while (is_valid) {
			try {
				parse_digit (ref p,output);
			} catch (ParseError err) {
				is_valid = false;
			}
		}
		return int.parse (output.str);
	}
	public static Die parse_die_or_constant (ref string p) throws ParseError
	{
		var static_part = parse_integer (ref p);
		var ch = p.get_char ();
		if (ch == 'd') {
			p = p.next_char ();
			ch = p.get_char ();
			if (ch == 'F') {
				p = p.next_char ();
				return new Die.fudge(static_part);
			} else if (ch.isdigit()) {
				var sides = parse_integer (ref p);
				return new Die (static_part,sides);
			} else {
				return new Die (static_part,6);
			}
		} 
		return new Die.constant (static_part);
	}

	public static List<Die> parse_dice (ref string p) throws ParseError 
	{
		var dice = new List<Die?> ();
		bool is_valid = true;
		bool negate = false;
		while (is_valid) {
			var die = parse_die_or_constant (ref p);
			if (negate) 
				die.const_or_number = -die.const_or_number;
			dice.append(die);
			var ch = p.get_char();
			while (ch == ' ') {
				p = p.next_char ();
				ch = p.get_char();
			}
			if (ch == '+') {
				negate = false;
				p = p.next_char ();
			    ch = p.get_char();
			    while (ch == ' ') {
				   p = p.next_char ();
				   ch = p.get_char();
			    }
			} else if (ch == '\0') {
				is_valid = false;
			} else if (ch == '-') {
				negate = true;
				p = p.next_char ();
			    ch = p.get_char();
			    while (ch == ' ') {
				   p = p.next_char ();
				   ch = p.get_char();
			    }
			} else {
			    throw new ParseError.NO_PARSE ("'+' or '-' or EOF");
			}
		}
		return dice;
	}

	static void roll_die (Die die, ref int total, ref bool fudge, ref bool tried_fudge) {
		if (die.sides == 0) {
			total += die.const_or_number;
			return;
		} 
		int min, max;
		if (die.is_fudge) {
			tried_fudge = true;
			min = -1;
			max = 1;
		} else {
			fudge = false;
			min = 1;
			max = die.sides;
		}
		for (int i = 0; i < die.const_or_number; i++) {
			total += Random.int_range(min, max + 1);
		}
	}

	static string roll_one_die_set (Die die, int adjustment) {
		bool fudge = true, tried_fudge = false;
		roll_die (die, ref adjustment, ref fudge, ref tried_fudge);
		if (fudge && tried_fudge && adjustment > 0) {
			return "+%d".printf(adjustment);
		}
		return "%d".printf(adjustment);
	}
	static string roll_multi_die_set (List<Die?> dice) {
		bool fudge = true, tried_fudge = false;
		int total = 0;
		foreach (Die die in dice) {
			roll_die (die, ref total, ref fudge, ref tried_fudge);
		}
		if (fudge && tried_fudge && total > 0) {
			return "+%d".printf(total);
		}
		return "%d".printf(total);
	}
	static string roll_skill_die (int skill,out bool critical, out int margin) {
		bool fudge = false, tried_fudge = false;
		int total = 0;
		roll_die(new Die(3,6),ref total, ref fudge, ref tried_fudge);
		int highest_success = skill<4?4:(skill>16?16:skill);
		margin = highest_success - total;
		critical = false;
		
		if (total < 5) critical = true;
		if (skill > 5 && total < 6) critical = true;
		if (skill > 14 && total < 7) critical = true;
		if (skill > 15 && total < 8) critical = true;
		
		if (total > 17) critical = true;
		if (skill < 16 && total > 16) critical = true;
		if (total >= skill + 10) critical = true;
		
		if (margin >= 0 && critical) {
			return "%d: Critical Success (margin: %d)".printf(total,margin);
		} else if (margin >= 0) {
			return "%d: Success (margin: %d)".printf(total,margin);
		} else if (critical) {
			return "%d: Critical Failure (margin: %d)".printf(total,-margin);
		} else {
			return "%d: Failure (margin: %d)".printf(total,-margin);
		}
	}

	static int main (string[] args) 
	{
		Gtk.init (ref args);
		// Gtk.Settings.get_default().gtk_theme_name;
		var app = new Main ();

		Gtk.main ();
		
		return 0;
	}
}
