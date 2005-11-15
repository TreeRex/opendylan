Module:    console-environment
Synopsis:  The command line version of the environment
Author:    Andy Armstrong
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      Functional Objects Library Public License Version 1.0
Dual-license: GNU Lesser General Public License
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

define abstract class <environment-main-command> (<basic-main-command>)
  constant slot %arguments :: false-or(<string>) = #f,
    init-keyword: arguments:;
  constant slot %start? :: <boolean> = #f,
    init-keyword: start?:;
  constant slot %debug? :: <boolean> = #f,
    init-keyword: debug?:;
  constant slot %profile? :: <boolean> = #f,
    init-keyword: profile?:;
  constant slot %play? :: <boolean> = #f,
    init-keyword: play?:;
  constant slot %share-console? :: <boolean> = #f,
    init-keyword: share-console?:;
/*---*** fill this in later.
// Debugger commands
"signalling-thread"
"other-threads"
"messages"
"crossref-threshold"
"limit-stack"
"component"
"dylan"
"profile"
"pre-command"
"command"
"noisy"
"quiet"
"pli"
"recover"
"end"
"p"
"e"

*/
end class <environment-main-command>;

define method execute-main-loop
    (context :: <server-context>, command :: <environment-main-command>)
 => (status-code :: <integer>)
  case
    command.%play? =>
      let command = make(<play-command>, server: context);
      execute-command(command);
    otherwise =>
      #f;
  end;
  next-method()
end method execute-main-loop;

define method execute-main-command
    (context :: <server-context>, command :: <environment-main-command>)
 => (status-code :: <integer>)
  local method run
	    (class :: subclass(<command>), #rest arguments) => ()
	  let command = apply(make, class, server: context, arguments);
	  execute-command(command)
	end method run;
  let code = next-method();
  if (code == $success-exit-code)
    if (command.%start? | command.%debug? | command.%profile?)
      run(<start-application-command>,
	  arguments:      command.%arguments,
	  debug?:         command.%debug?,
	  profile?:       command.%profile?,
	  share-console?: command.%share-console?);
      execute-main-loop(context, command)
    else
      $success-exit-code
    end
  else
    code
  end
end method execute-main-command;


/// Main command
///
/// This is the version used by external editions.

define class <main-command> (<environment-main-command>)
end class <main-command>;

define command-line main => <main-command>
    (summary:       "command-line version of Functional Developer",
     documentation: "Command-line version of Functional Developer.")
  optional project :: <file-locator>  = "the project to be built";
  keyword  arguments :: <string> = "arguments for the project's application";

  keyword build-script :: <file-locator> = "the (Jam) build script to use";
  keyword target :: <symbol> = "the target";

  flag help          = "show this help summary";
  flag logo          = "displays the copyright banner";
  flag debugger      = "enter the debugger if this program crashes";
  flag echo-input    = "echoes all input to the console";

  flag import        = "import the project";
  flag build         = "build the project";
  flag compile       = "compile the project";
  flag link          = "link the project";
  flag clean         = "force a clean build of the project";
  flag release       = "build a release for the project";
  flag subprojects   = "build subprojects as well if necessary";
  flag force         = "force relink the executable";

  flag play          = "open and debug the playground project";
  flag start         = "start the project's application";
  flag debug         = "debug the project's application";
  flag profile       = "profile the execution of the application";
  flag share-console = "share the console with the application";
end command-line main;


/// Internal main command
///
/// This is the version used by the internal edition.

define class <internal-main-command> (<environment-main-command>)
end class <internal-main-command>;

define command-line internal-main => <internal-main-command>
    (summary:       "command-line version of Functional Developer",
     documentation: "Command-line version of Functional Developer.")
  optional project :: <file-locator> = "the project to be built";
  keyword  arguments :: <string> = "arguments for the project's application";

  keyword build-script :: <file-locator> = "the (Jam) build script to use";
  keyword target :: <symbol> = "the type of executable to generate";
  keyword debug-info :: <symbol>  = "control the debug info generated";

  flag help             = "show this help summary";
  flag logo             = "displays the copyright banner";
  flag debugger         = "enter the debugger if this program crashes";
  flag echo-input       = "echoes all input to the console";

  flag import           = "import the project";
  flag build            = "build the project";
  flag compile          = "compile the project";
  flag link             = "link the project";
  flag clean            = "force a clean build of the project";
  flag release          = "build a release for the project";
  flag subprojects      = "build subprojects as well if necessary";
  flag force            = "force relink the executable";

  flag play             = "open and debug the playground project";
  flag start            = "start the project's application";
  flag debug            = "debug the project's application";
  flag profile          = "profile the execution of the application";
  flag share-console    = "share the console with the application";

  // Internal-only options
  keyword personal-root :: <directory-locator> = "personal area root";
  keyword system-root   :: <directory-locator> = "system area root";
  flag unify            = "combine the libraries into a single executable";
  flag profile-commands = "profile the execution of each command";

  // Backwards-compatibility options for pentium-dw users
  flag not-recursive    = "don't build subprojects as well";
  flag save             = "save compiler databases";
  flag link-dll         = "link as a DLL";
  flag link-exe         = "link as an EXE";
  flag gnu-exports      = "link the GNU exports";
  keyword messages :: <symbol>  = "control the progress messages generated";
end command-line internal-main;