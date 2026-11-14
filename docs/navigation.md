# Navigation and login — November 10–12 milestone

Source: the user-supplied `CS310_Group25_Step2.1.pdf`, especially the flow on
page 1 and login states on page 2. The task list says 15 routes, but the PDF has
16 distinct screens: page 14 contains both Profile and Edit profile. Both have
separate routes so the PDF flow is reachable. Dialogs do not get extra routes.

| Screen | Route | Current implementation |
| --- | --- | --- |
| Login | `/login` | Full login UI with inline validation and local logo |
| Forgot password | `/forgot-password` | Scaffold |
| Sign up: account | `/sign-up` | Existing account form connected |
| Sign up: profile | `/sign-up/profile` | Existing profile form connected |
| Verify email | `/verify-email` | Scaffold |
| Home | `/` | Scaffold |
| University detail | `/universities/:id` | Scaffold, retains Home tab |
| Post detail | `/posts/:id` | Scaffold above the bottom bar |
| New post | `/posts/new?universityId=...` | Scaffold above the bottom bar |
| Places | `/places` | Scaffold |
| Add place | `/places/new` | Scaffold above the bottom bar |
| Matches | `/matches` | Scaffold |
| Profile | `/profile` | Scaffold with Edit profile and Log out navigation |
| Edit profile | `/profile/edit` | Scaffold with Add exchange navigation |
| Add exchange | `/profile/exchanges/new` | Scaffold |
| Add university | `/add-university` | Scaffold reachable from Home and sign-up |

`AppRoutes` defines links; dynamic IDs are URL encoded. Named routes are also
available in `app_router.dart`. `/posts/new` is registered before the dynamic
post route. Unknown links show a recoverable Page not found screen.

## AppShell

The bottom bar has exactly the PDF's four destinations: Home, Places, Matches,
Profile. `StatefulShellRoute.indexedStack` preserves each tab's navigation stack.
Tapping the selected tab again returns it to its root. Main screens and university
detail keep the bottom bar; auth, forms and post detail use the root navigator.
Back from a pushed form restores its caller. Directly opened scaffolds provide a
fallback back destination. Feature teams replace the scaffold bodies without
changing this contract. Preview links carry the explicit ID `preview`, not real data.

## Login and common widgets

The login follows the PDF hierarchy: bundled logo, app name, subtitle, university
email, password with visibility toggle, Forgot password, Log in, and Sign up.
The logo in `assets/images/erasmus_hub_logo.png` was extracted unchanged from the
PDF's embedded 256×256 image; it requires no network or additional package.
The existing Poppins theme and color tokens are retained.

Email validation permits only `.edu` / `.edu.tr`, including subdomains, while
rejecting malformed domains and lookalike suffixes. Password is required and has
an eight-character minimum, consistent with the account form. Errors are inline;
password values are never trimmed, persisted or logged. Keyboard Next/Done,
password visibility, scrolling and autofill are supported.

This is the Step 2.1 **UI prototype**, not Firebase authentication. As specified
in the PDF, valid Log in opens Home; no backend login, real session, password
reset, verification email or authorization boundary is claimed. Direct routes
remain available for feature development. The other feature bodies and their
submit/confirmation behavior remain outside this milestone.

Shared widgets live under `lib/shared/widgets/`:

- `AppButton`: filled/outlined, disabled and loading states; loading blocks repeat taps.
- `AppTextField`: accessible external label, controller, inline validator, input action,
  autofill, suffix action and multiline support.
- `AppCard`: padded card with optional tappable Material surface.
- `StarRating`: read-only fractional stars or controlled accessible 1–5 input.
- `UserAvatar`: image with Unicode initials fallback, including failed image loads.

## Validation

`flutter analyze` and `flutter test` cover all 16 direct routes plus unknown-link
recovery, login errors/success/password visibility, connected sign-up navigation,
tab selection/restoration, form overlays, logout, common-widget behavior and a
320×568 login viewport with 1.6× text and keyboard inset.

Reference renders at 390×844, using the bundled fonts and logo:

| Default | Invalid university email |
| --- | --- |
| ![Login](screenshots/login.png) | ![Inline validation](screenshots/login-error.png) |

These are Flutter widget renders, not physical-device screenshots.
