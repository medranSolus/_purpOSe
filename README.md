# _purpOSe
Operating System project

## Info
**Author:** Marek Machliński

**Project start:** 24.03.2019

**Documentation:** Doxygen

## Project structure
| Directory | Overview |
| --- | --- |
| cross | Sources and headers for platform independent code. |
| makeconfig | Configuration files included to main makefile. |
| makeconfig/rules | Rules for compilation of every folder in project structure. |
| utils | Utility scripts and tools needed to automate build process and instalation of cross-compiler. |
| utils/quick_tools | Sources and compiled tools that help during build process. |
| x86 | Sources and headers for x86 specyfic code. |

## Build process
### Creation of toolchain
Compilation process needs specyfic toolchain to create OS for desired architecture. Below scripts were made to automate this process:
  - *setup.sh* - Creates all components needed to start working on project. If some packages needs to be installed first, proper message will appear.
  - *utils/install_env_tools.sh* - If you need to install only cross compiler run this script.
  - *utils/install_quick_tools.sh* - After creation of new tools or editing existing ones run this script to recreate them.

**WARNING!** All tools are meant to be run from project root directory. To avoid unexpected and devastating behaviour newer run them from any other directory!

### Project compilation
After creation of toolchain **GNU Make** is used to compile project. Not specifying any target will create disk images for all supported architectures. Typing architecture name will create image only for that target. Supported architectures:
  - **x86**

## Makefile structure
| File | Overview |
| --- | --- |
| makefile | Main file containing tools locations and main rules for each module and architecture. |
| makeconfig/directories.mk | Variables ending with *_DIR* specifying directories for each module and SYSROOT directory. |
| makeconfig/files.mk | Variables ending with *_OBJ* and *_SRC* containing all object and source files for specyfic modules. |
| makeconfig/flags.mk | Variables with flags needed for compilation of specyfic target architectures. Variables here ends with *_FLAGS*, *_INC* or *_DEFINES* (only for OS specyfic defines). |
| makeconfig/rules.mk | Summary file containing includes of pattern rules for each module and directory in source tree. When creating new module add it's includes here. |
| makeconfig/rules/* | Location of pattern rules for each module and language. This files have to be included to *makeconfig/rules.mk*. When adding new module simply create new file for each language that this module will be made of. When creating new directories in source tree add new rule in one of module files here to compile files in newly created catalog. |

## Code conventions
To unify code style here are rules followed by this project:
  - Makefile variables are named with **ALL_CAPS**.
  - Macro, constants, global variables and defines are named with **ALL_CAPS**.
  - Functions and variables are named with **snake_case**.
  - Assembly functions have to be preceded with '_'.
  - Structures and other data types are named with **PascalCase**.
  - Enum types are named with **snake_case** preceded with enum name, ex. enum MyColor { MyColor_light_blue }.
  - Avoid short names, let every function describe itself but don't make them too long. For header functions that MAY (think twice) need additional description, add comment.
  - Every assembly funtion needs to be in seperate file. Only bootloader is exception.
  - Try to keep not connected functions in seperate files when possible. If so for every header create directory containing such functions with same name as header file.
  - No space before asterisks or ampersands and one after in type declarations.

---
Tips:
  - Do not git clone into directory tree which includes whitespaces.
