local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

ls.add_snippets("cpp", {
    s("snipps", {
        t({
            "/*",
            "beg",
            "mint",
            "bpow",
            "Floor",
            "Ceil",
            "*/",
            "",
        })
    }),

    s("beg", {
        t({
            "#include<bits/stdc++.h>",
            "using namespace std;",
            "using ll = long long;",
            "using ld = long double;",
            "#define TESTCASE",
            "//#define TIME",
            "#ifdef DEBUG",
            "#include \"/home/pouya/dev/cp/lib/debug.cpp\"",
            "#else",
            "#define dbg(...)",
            "#define Solve solve",
            "#endif",
            "#define nl '\\n'",
            "", "",
        }),

        t({ "void solve(int tc) {", "\t"}),
        i(1, "//code here"),
        t({"", "}", "", ""}),

        t({
            "int32_t main() {",
            "\tios_base::sync_with_stdio(false);",
            "\tcin.tie(nullptr);",
            "\tint t = 1;",
            "\t",
            "\t#ifdef TESTCASE",
            "\tcin >> t;",
            "\t#endif",
            "\tfor (int i=1; i<=t; i++) {",
            "\t\tSolve(i);",
            "\t}",
            "\treturn 0;",
            "}",
            "",
        })
    }),

    s("Floor", {
        t({
            "auto Floor = [&] (int a, int b) {",
            "\tassert(b > 0);",
            "\treturn a>=0? a/b: a/b-1;",
            "}",
            "",
        })
    });

    s("Ceil", {
        t({
            "auto Ceil = [&] (int a, int b) {",
            "\tassert(b > 0);",
            "\treturn a>=0? (a+b-1)/b: (a+b-1)/b+1;",
            "}",
            "",
        })
    });

    s("bpow", {
        t({"ll bpow(ll a, int p) {",
            "\tll ans = 1;",
            "\twhile (p) {",
                "\t\tif (p&1) {",
                    "\t\t\tans *= a;",
                "\t\t}",
                "\t\ta *= a;",
                "\t\tp >>= 1;",
            "\t}",
            "\treturn ans;",
        "}", "",
        }),
    }),


    s("mint", {
    t({
"template<ll mod>",
"struct Mint {",
    "\tll x;",
    "\tMint() :x(0) {}",
    "\tMint(ll a) :x((a%mod+mod)%mod) {}",
    "\texplicit operator ll() const { return x; }",
    "\texplicit operator int() const { return x; }",
    "\t",
    "\tMint& operator+=(const Mint& a) { if ((x += a.x) >= mod) x-=mod; return *this;}",
    "\tMint& operator-=(const Mint& a) { if ((x -= a.x) < 0) x+=mod; return *this;}",
    "\tMint& operator*=(const Mint& a) { if ((x *= a.x) >= mod) x%=mod; return *this;}",
    "\tfriend Mint mpow(Mint a, ll p) { assert(p >= 0); return p==0?1:mpow(a*a, p/2)*(p&1?a:1); }",
    "\tMint& operator/=(const Mint& a) { if ((x *= (ll)mpow(a, mod-2)) >= mod) x%=mod; return *this;}",
    "\t",
    "\tfriend Mint operator+(Mint a, Mint b) { return a += b; }",
    "\tfriend Mint operator-(Mint a, Mint b) { return a -= b; }",
    "\tfriend Mint operator*(Mint a, Mint b) { return a *= b; }",
    "\tfriend Mint operator/(Mint a, Mint b) { return a /= b;}",
    "\t",
    "\tbool operator<(const Mint& a)const { return x < a.x;}",
    "\tbool operator==(const Mint& a)const { return x == a.x;}",
    "\t",
    "\tfriend istream& operator>>(istream& i, Mint& a) { i >> a.x; return i;}",
    "\tfriend ostream& operator<<(ostream& o, const Mint& a) {o << a.x; return o;}",
"};",
"const int mod1 = 1e9+7, mod2 = 998244353;",
"using  mi = Mint<mod1>;",
    })}),

})
