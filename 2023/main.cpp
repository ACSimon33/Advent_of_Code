//** -std=c++17
#include <type_traits>
//** Just a helper to have a 'false' value which depends on a template
//** parameter.
template<typename T> constexpr bool always_false_v = false;
//** Causes substitution failure when checking for member function.
template <typename T, typename...> struct enable_struct_t { using type = T; };
template <typename T, typename... U> using enable_t = typename enable_struct_t<T, U...>::type;
//** Matches if type is copy constructable.
template <typename T>
  auto clone(T const& from, std::enable_if_t<std::is_copy_constructible_v<T>, int>) {
  return new T(from);
}
//** Matches if type is not copy constructable, but it has a clone()
//** member function.
template <typename T>
  auto clone(T const& from, std::enable_if_t<
             !std::is_copy_constructible_v<T>,
             enable_t<int, decltype(std::declval<T>().clone())>>) {
  return from.clone();
}
//** Default match with lower precedence (because of
//** int->long). Issues compilation error (static_assert). Lower
//** precedence important, since otherwise we'd get ambiguity errors.
template <typename T>
  auto clone(T const& from, long) {
  //** always_false_v required to have a template type dependency...
  static_assert(always_false_v<T>, "Please implement either copy constructor, or clone function for the type printed above or below in 'always_false_v<...>'");
  return new T();
}
struct has_copy_t {
  has_copy_t() = default;
  has_copy_t(has_copy_t const&) = default;
};
struct has_clone_t {
  has_clone_t() = default;
  has_clone_t(has_clone_t const&) = delete;
  has_clone_t* clone() const { return nullptr; }
};
struct has_nothing_t {
  has_nothing_t() = default;
  has_nothing_t(has_nothing_t const&) = delete;
};
int main() {
  has_copy_t has_copy;
  auto * has_copy_clone = clone(has_copy, int());
  //** This results in static_assert error.
  has_nothing_t has_nothing;
  auto * has_nothing_clone = clone(has_nothing, int());
  has_clone_t has_clone;
  auto * has_clone_clone = clone(has_clone, int());
}