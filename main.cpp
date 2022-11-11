/*{{{*/
// USACO template: https://github.com/bqi343/USACO/blob/master/Implementations/content/contest/TemplateLong.cpp

#pragma GCC optimize("Ofast,unroll-loops")
#pragma GCC target("avx2,bmi,bmi2,lzcnt,popcnt,tune=native")

#ifdef LOCAL // g++ -DLOCAL ...
// precompiled headers
// g++ -std=c++17 -Ofast -funroll-loops -mavx2 -mbmi -mbmi2 -mlzcnt -mpopcnt -mtune=native bits/stdc++.h
#include "bits/stdc++.h"
#else
#include <bits/stdc++.h>
#endif

using namespace std;

#define tcT template<typename T
#define tcTT template<typename... T
#define tcTUU template<typename T, typename... U

using str = string;
using stv = string_view;
using db = double;
using ll = long long;
using ld = long double;

using pii = pair<int,int>;
using pll = pair<ll,ll>;
#define mp make_pair

tcT> using vec = vector<T>;
tcT, size_t SZ> using arr = array<T,SZ>;
#define pb push_back
#define eb emplace_back
#define ppb pop_back
#define rsz resize
#define ft front()
#define bk back()
#define sz(x) int(x.size())
#define bg(x) begin(x)
#define all(x) bg(x), end(x)
#define rall(x) x.rbegin(), x.rend()

#define lb lower_bound
#define ub upper_bound
tcT> int ilb(vec<T> &a, const T &b) { return int(lb(all(a),b)-bg(a)); }
tcT> int iub(vec<T> &a, const T &b) { return int(ub(all(a),b)-bg(a)); }

#define FOR(i,a,b) for (int i = (a); i < (b); i++) // from a to b-1
#define F0R(i,a) FOR(i,0,a)
#define ROF(i,a,b) for (int i = (b)-1; i >= (a); i--) // from b-1 to a
#define R0F(i,a) ROF(i,0,a)
#define EACH(x,v) for (auto &x : v)

tcT> using mxq = priority_queue<T>; // max-heap
tcT> using mnq = priority_queue<T,vector<T>,greater<T>>; // min-heap

constexpr int pct(int x) { return __builtin_popcount(x); }
constexpr int clz(int x) { return __builtin_clz(x); }
constexpr int ctz(int x) { return __builtin_ctz(x); }
constexpr int msk(int x) { return (1<<x)-1; } // generate x-bit mask
constexpr int cbt(int x) { return x == 0 ? 0 : 32-clz(x); } // count number of bits used for x

constexpr int dx[4] = {-1, 0, 1, 0}, dy[4] = {0, 1, 0, -1}; // clockwise
//constexpr int dx8[8] = {-1, -1, 0, 1, 1, 1, 0, -1}, dy8[8] = {0, 1, 1, 1, 0, -1, -1, -1}; // clockwise

constexpr int MOD = 1e9 + 7; // 1'000'000'007
constexpr int mod(int a, int b) { return (a % b + b) % b; }

// y_combinator (recursive lambda): https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0200r0.html
template<typename Func>
struct y_combinator_result {
    Func func;

    tcT>
    explicit y_combinator_result(T &&func) : func(std::forward<T>(func)) {}
    tcTT>
    decltype(auto) operator()(T &&...t) { return func(std::ref(*this), std::forward<T>(t)...); }
};
template<typename Func>
decltype(auto) y_combinator(Func &&func) { return y_combinator_result<std::decay_t<Func>>(std::forward<Func>(func)); }

#define endl "\n" // https://usaco.guide/general/fast-io?lang=cpp

// print pair of A,B
template <typename A, typename B> ostream& operator<<(ostream &os, const pair<A,B> &p) { return os << '(' << p.first << ", " << p.second << ')'; }
// print array/vector of T
template <typename T_container, typename T = typename enable_if<!is_same<T_container, string>::value, typename T_container::value_type>::type> ostream& operator<<(ostream &os, const T_container &cont) { os << '{'; string sep; for (const T &x : cont) os << sep << x, sep = ", "; return os << '}'; }

#ifdef DEBUG // g++ -DDEBUG ...
void dbg_out() { cerr << endl; }
tcTUU> void dbg_out(T t, U... u) { cerr << ' ' << t; dbg_out(u...); }
#define dbg(...) cerr << 'L' << __LINE__ << "\t(" << #__VA_ARGS__ << "):", dbg_out(__VA_ARGS__)
#else
#define dbg(...)
#endif

inline namespace FileIO {
    void setIn(str s) { freopen(s.c_str(), "r", stdin); }
    void setOut(str s) { freopen(s.c_str(), "w", stdout); }
    void setIO(str s = "") {
        cin.tie(0)->sync_with_stdio(0);
        if (sz(s)) setIn(s+".inp"), setOut(s+".out");
    }
};

/*}}}*/
//#define NTESTS
//#define IOFILE "/tmp/a"
void solve(int __tc) {
}
/*{{{*/
int main(int argc, const char **argv) {
#ifdef IOFILE
    setIO(IOFILE);
#else
    setIO();
#endif

    int ntests = 1;
#ifdef NTESTS
    cin >> ntests;
#endif
    FOR(__tc, 1, ntests+1) {
        solve(__tc);
    }

    return 0;
}/*}}}*/
