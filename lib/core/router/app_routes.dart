/// URL contract for the Step 2.1 prototype. Keep feature links here.
abstract final class AppRoutes {
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const signUpAccount = '/sign-up';
  static const signUpProfile = '/sign-up/profile';
  static const verifyEmail = '/verify-email';
  static const home = '/';
  static const places = '/places';
  static const addPlace = '/places/new';
  static const matches = '/matches';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const myPosts = '/profile/posts';
  static const addExchange = '/profile/exchanges/new';
  static const addUniversity = '/add-university';
  static String university(String id) =>
      '/universities/${Uri.encodeComponent(id)}';
  static String post(String id) => '/posts/${Uri.encodeComponent(id)}';
  static String newPost(String universityId) => Uri(
    path: '/posts/new',
    queryParameters: {'universityId': universityId},
  ).toString();
}
