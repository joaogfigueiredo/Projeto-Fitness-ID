---
name: Fitness ID Clay
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1b1b1b'
  surface-container: '#1f1f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#e9bcb5'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#303030'
  outline: '#b08781'
  outline-variant: '#5f3f3a'
  surface-tint: '#ffb4a8'
  primary: '#ffb4a8'
  on-primary: '#690000'
  primary-container: '#e60000'
  on-primary-container: '#fff7f5'
  inverse-primary: '#c00000'
  secondary: '#c7c6c6'
  on-secondary: '#303031'
  secondary-container: '#464747'
  on-secondary-container: '#b5b5b5'
  tertiary: '#ffb3b1'
  on-tertiary: '#5f1319'
  tertiary-container: '#b55455'
  on-tertiary-container: '#fff7f6'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdad4'
  primary-fixed-dim: '#ffb4a8'
  on-primary-fixed: '#410000'
  on-primary-fixed-variant: '#930100'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#ffdad8'
  tertiary-fixed-dim: '#ffb3b1'
  on-tertiary-fixed: '#410007'
  on-tertiary-fixed-variant: '#7e2a2d'
  background: '#131313'
  on-background: '#e2e2e2'
  surface-variant: '#353535'
typography:
  headline-xl:
    fontFamily: Anybody
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 52px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Anybody
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Anybody
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Anybody
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
  body-lg:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Lexend
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Lexend
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  container-padding: 32px
  element-gap: 20px
  section-margin: 40px
  inner-padding: 24px
  stack-sm: 12px
---

## Brand & Style

The design system is engineered for a high-energy, premium fitness experience that feels physically tangible. By utilizing **Claymorphism**, the interface moves away from flat digital planes into a space of soft, 3D volumes that invite interaction. The brand personality is aggressive yet approachable—combining the intensity of performance athletics (via the vibrant red and black palette) with the friendly, ergonomic "squishiness" of clay-like UI elements. 

The target audience is fitness enthusiasts who value modern aesthetics and tactile feedback. The UI should evoke a sense of "premium gear"—like high-end athletic equipment or silicone-molded wearables. The floating, organic nature of the elements suggests agility and movement, perfectly aligning with a fitness-focused product.

## Colors

The palette is rooted in a deep, absolute black background to provide a high-contrast stage for the Claymorphic elements. 

- **Primary Red (#e60000):** Reserved for high-priority actions, active states, and critical performance metrics. It represents energy and urgency.
- **Secondary Gray (#878787):** Used for non-interactive elements, secondary information, and subtle depth transitions within the clay containers.
- **Accent Soft Red (#d86f6f):** Applied to secondary interactive elements or to provide tonal variety in data visualization.
- **Surface Treatment:** Colors are rarely flat. Every surface uses a subtle gradient or inner shadow to maintain the 3D volume required by the claymorphic style.

## Typography

This design system uses a dual-font approach to balance athletic aggression with readability. 

**Anybody** is the headline face. Its variable nature and bold, slightly wide proportions command attention and feel modern and technical. Use it for workout titles, large metric callouts (calories, heart rate), and section headers.

**Lexend** is used for all body text and UI labels. Designed specifically for readability, its clear, open letterforms ensure users can consume data quickly during high-intensity activity. 

All headings should favor a tight letter-spacing to reinforce the "bold" brand identity, while labels and small text use slightly increased tracking for clarity against the high-contrast dark background.

## Layout & Spacing

The layout philosophy is based on a **Fluid Grid** with generous "breathing room" to accommodate the large shadows and rounded corners of the claymorphic elements. 

- **Grid:** A 12-column system for desktop and a 4-column system for mobile. 
- **Safety Margins:** Mobile layouts must maintain a minimum of 24px side margins to prevent the 3D shadows from being clipped by the screen edge.
- **Rhythm:** A 4px baseline grid is used, but primary components follow a 20px/32px spacing rule. Large gaps are essential to allow the "floating" effect of the elements to be perceptible.
- **Reflow:** On mobile, components stack vertically, maintaining the 20px gap. On tablet and desktop, cards may span multiple columns but should never lose their distinctive roundedness.

## Elevation & Depth

Depth is the defining characteristic of this design system. It is achieved through a specific "Claymorphism" stack:

1.  **Outer Shadow:** Large, blurry shadows using `rgba(0,0,0,0.3)` or tinted with the primary color when on an active element. This creates the "floating" effect.
2.  **Inner Shadow (Light):** A top-left inner shadow using `rgba(255,255,255,0.15)` to simulate a light source hitting the top edge of the "clay" volume.
3.  **Inner Shadow (Dark):** A bottom-right inner shadow using a darker version of the component's base color to simulate the curve of the object away from the light.
4.  **Surface Gradient:** A very subtle linear gradient (top-left to bottom-right) is applied to all containers to reinforce the 3D curvature.

Objects do not sit "on" the surface; they float "above" it. The higher the elevation (e.g., a modal), the larger the outer shadow blur.

## Shapes

The shape language is dominated by extreme roundedness. Sharp corners are entirely absent from the system to maintain the organic, clay-like feel. 

- **Base Components:** 20px radius.
- **Large Cards/Containers:** 32px radius.
- **Interactive Elements:** Use the `pill-shaped` (level 3) setting for buttons and chips to maximize the tactile, "squishy" appearance.
- **Icons:** Should use a rounded terminal and a minimum stroke weight of 2px to match the visual weight of the typography.

## Components

### Buttons
Primary buttons use the Vibrant Red (#e60000) base with the dual inner-shadow treatment. Text is white, Bold Lexend, Uppercase. When pressed, the inner shadows invert or deepen to simulate the button being physically compressed.

### Cards & Workout Tiles
Large containers for workout data or plan overviews. These use a slightly desaturated black or dark gray surface to stand out against the absolute black background. They must feature the 32px corner radius and the full claymorphic shadow stack.

### Chips & Tags
Used for categories like "Strength," "Cardio," or "HIIT." These are pill-shaped with a 2px border or a soft clay-fill. In active states, they take on the accent red (#d86f6f).

### Input Fields
Inputs are recessed clay elements. Instead of an outer shadow, they use a prominent inner shadow to look "stamped" into the interface. 

### Progress Rings
For fitness tracking, use thick stroke-weight rings with rounded caps. The background track should be the secondary gray, and the active progress should be a gradient of the primary red.

### Floating Action Button (FAB)
The core "Start Workout" button. This is the highest elevation element in the system, featuring an exaggerated outer shadow and a vibrant primary red fill.