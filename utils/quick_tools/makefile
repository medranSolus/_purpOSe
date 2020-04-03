QUICK_TOOLS_CPP = $(patsubst %.cpp, bin/%, $(shell find src/ -type f -name "*.cpp" -exec basename {} \;))

.PHONY: all
all: bin_dir $(QUICK_TOOLS_CPP)
	@echo Quick tools created.

bin/%: src/%.cpp
	@g++ -std=c++17 $< -o $@

.PHONY: bin_dir
bin_dir:
	@mkdir -p bin

.PHONY: clean
clean:
	@rm -f bin/*