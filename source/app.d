//#!MCVM ldc2 -g --vgc --gcc=clang --link-defaultlib-debug --od=build --of=build/aa ${file} --run 


//#!MCVM ldc2 -v --output-mlir ${file}



//#!MCVM ldc2 -v -preview=bitfields -defaultlib=phobos2-ldc,druntime-ldc ${file} -mtriple=wasm32-unknown-emscripten --mattr=+simd128,+exception-handling \
//#!MCVM -L--no-entry

//#!MCVM dub -v build
// import core.stdc.stdio;
// import std.stdio;
// import std.exception;

// // extern (C) void _start() {} // should not be needed

// void main() {
// 	// std.exception.errnoString(0);
// 	ErrnoException e;
// 	auto x = [1, 2, 3,];
// 	writeln(x);
// 	writeln(whatever(b : 3,));
// 	// writeln("Edit source/app.d to start your project.");
// 	// fprintf(stderr, "Edit source/app.d to start your project.\n");
// }

// auto whatever(int a = 23, int b,) {
// 	return 33;
// }

import core.stdc.stdlib : malloc;
// import std.stdio : writeln;
import core.memory;
void writeln(T...)(T args) {
    import std.stdio : writeln;
    // writeln(args);
}

struct Foo {
    int xxxvar;
}

struct Owned(T) {
    this(void* v) nothrow @nogc {
        debug writeln("constructor");
        this.v = cast(T*) v;
    }

    ~this() nothrow @nogc {
        debug writeln("destructor");
        import core.stdc.stdlib : free;

        if (v) {
            free(v);
            debug writeln("free");
        }
    }

    static typeof(this) malloc() nothrow @nogc // same attribute as stdlib.malloc
    {
        return typeof(this)(.malloc(T.sizeof));
    }

    T* v;
    alias this = v;
}

struct Strr {
    bool s_x;
    bool s_y;
    bool s_z;
    float s_a = 0;
    float s_b;
    float s_c;
    ~this() {
        writeln("st dtor");
    }
}

class CLclcl {
    bool c_x;
    bool c_y;
    bool c_z;
    float c_a = 0;
    float c_b;
    float c_c;
    this() {
        writeln("CLclcl");
    }
    ~this() {
        writeln("CLclcl dtor");
    }
}

void fn() {
    { // Simulate scope
        auto foo = Owned!Foo(malloc(Foo.sizeof));
        foo.xxxvar = 10;
        assert(foo.xxxvar == 10);
        writeln(foo.xxxvar);
    }

    { // Simulate scope
        auto foo = Owned!Foo.malloc;
        foo.xxxvar = 100;
        assert(foo.xxxvar == 100);
        writeln(foo.xxxvar);
    }

    auto a_var = "a" ~ "b";
    for (int i = 0; i < 10; i++) {
        writeln(i);
        a_var ~= "cc";
    }
    auto a_x_var = new int;

    typeof(a_x_var).stringof.writeln;
    // GC.free(x);
    __delete(a_x_var);
    auto stack_strr = new Strr;
    auto stt_inst = Strr();

    auto cl_inst = new CLclcl();
    "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
        .writeln;
    cl_inst.writeln;
    static foreach (what; __traits(allMembers, CLclcl)) {
        static if (__traits(compiles, __traits(getMember, cl_inst, what).writeln)) {
            i"$(what): $(__traits(getMember, cl_inst, what))".writeln;
        } else {
            i"$(what): none".writeln;
        }

    }
    "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
        .writeln;
    stt_inst.writeln;
    static foreach (what; __traits(allMembers, Strr)) {
        what.writeln;
        static if (__traits(compiles, __traits(getMember, stt_inst, what).writeln)) {
            i"$(what): $(__traits(getMember, stt_inst, what))".writeln;
        } else {
            i"$(what): none".writeln;
        }
    }
    "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
        .writeln;

    __traits(classInstanceSize, CLclcl).writeln;
    CLclcl.sizeof.writeln;

    GC.collect();

    writeln(a_var);
}

void main() {
    fn();
    writeln("done");
}
