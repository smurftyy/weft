import 'package:flutter/painting.dart';
import '../primitives.dart';
import '../token_types.dart';
import 'paradigm_bindings.dart';

/// Skeuo binding — dimensional, natural mapping, warm ground.
/// Ported from AtomTile/WidgetCard/SectionHeader/AppIcon skeuo branches.
class SkeuoBindings extends ParadigmBindings {
  @override
  Paradigm get id => Paradigm.skeuo;

  @override
  SurfaceStyle container() => const SurfaceStyle(
        gradient: Prims.warmWallpaper,
        borderColor: null,
        shadows: <BoxShadow>[],
      );

  @override
  double get tileRadius => Prims.rad2Xl; // 20

  @override
  SurfaceStyle tileGround(WState s) {
    switch (s) {
      case WState.selected:
        return const SurfaceStyle(
          gradient: Prims.skeuoOnFill,
          borderColor: Color(0x8C1E6FFF),
          shadows: <BoxShadow>[
            BoxShadow(color: Color(0x6B1E6FFF), offset: Offset(0, 10), blurRadius: 22),
          ],
        );
      case WState.pressed:
        return const SurfaceStyle(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Prims.coolPressTop, Prims.coolPressBot],
          ),
          borderColor: Color(0x1A14161E),
        );
      case WState.disabled:
        return const SurfaceStyle(color: Prims.ink100, borderColor: Prims.ink200);
      case WState.enabled:
      case WState.focus:
        return const SurfaceStyle(
          gradient: Prims.skeuoTileEnabled,
          borderColor: Color(0x0F14161E),
          shadows: Prims.skeuoLift,
        );
    }
  }

  @override
  Color tileInk(WState s) => switch (s) {
        WState.selected => Prims.white,
        WState.disabled => Prims.ink400,
        _ => Prims.ink900,
      };

  @override
  Color tileStatus(WState s) => switch (s) {
        WState.selected => const Color(0xE6FFFFFF),
        WState.disabled => Prims.ink400,
        _ => Prims.ink600,
      };

  @override
  Color? tileLabelChip(WState s) => null; // skeuo has no opaque label chip

  @override
  SurfaceStyle sectionPlate() => SurfaceStyle.none; // skeuo: text sits on ground

  @override
  Color sectionTitleColor() => Prims.ink800;

  @override
  Color sectionCaptionColor() => Prims.ink550;

  @override
  double get appIconRadius => Prims.rad3Xl; // 22

  @override
  List<BoxShadow> get appIconShadow => Prims.appIconShadowSkeuo;

  @override
  double get titleSize => Prims.textTitle; // 20

  @override
  double get captionSize => Prims.textStatus; // 12

  // Warm track ground shared by slider + toggle-off (source: #D8D2C6→#E9E3D8).
  static const _warmTrack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD8D2C6), Color(0xFFE9E3D8)],
  );
  static const _raisedThumb = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Prims.coolTop, Prims.coolBot],
  );

  @override
  SurfaceStyle sliderTrack(WState s) => const SurfaceStyle(
        gradient: _warmTrack,
        borderColor: Color(0x0F14161E),
        insets: [InsetSpec.skeuoGroove],
      );

  @override
  SurfaceStyle sliderFill(WState s) => s == WState.disabled
      ? const SurfaceStyle(color: Color(0xFFBFC2C9))
      : const SurfaceStyle(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Prims.blue700, Prims.blue400],
          ),
          insets: [InsetSpec.skeuoFillShade, InsetSpec.skeuoFillEdge],
        );

  @override
  SurfaceStyle sliderThumb(WState s) => s == WState.disabled
      ? const SurfaceStyle(color: Color(0xFFCFCFCF))
      : const SurfaceStyle(
          gradient: _raisedThumb,
          shadows: [BoxShadow(color: Color(0x4D14161E), offset: Offset(0, 3), blurRadius: 7)],
          insets: [InsetSpec.skeuoTopHighlight],
        );

  @override
  SurfaceStyle toggleTrack(WState s) {
    switch (s) {
      case WState.selected:
        return const SurfaceStyle(
          gradient: Prims.skeuoOnFill,
          borderColor: Color(0x8C1E6FFF),
          insets: [InsetSpec.skeuoToggleOnHighlight, InsetSpec.skeuoToggleOnSeat],
        );
      case WState.disabled:
        return const SurfaceStyle(color: Color(0xFFE4E3DE), borderColor: Color(0xFFDAD9D3));
      default:
        return const SurfaceStyle(
          gradient: _warmTrack,
          borderColor: Color(0x1A14161E),
          insets: [InsetSpec.skeuoToggleGroove],
        );
    }
  }

  @override
  SurfaceStyle toggleThumb(WState s) => s == WState.disabled
      ? const SurfaceStyle(color: Color(0xFFCFCFCF))
      : const SurfaceStyle(
          gradient: _raisedThumb,
          shadows: [BoxShadow(color: Color(0x4714161E), offset: Offset(0, 3), blurRadius: 6)],
          insets: [InsetSpec.skeuoTopHighlight],
        );

  @override
  double get chipRadius => Prims.radSm; // 10

  @override
  bool get chipUppercase => false;

  @override
  SurfaceStyle chipGround(WState s) {
    switch (s) {
      case WState.selected:
        return const SurfaceStyle(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Prims.blue400, Prims.blue500],
          ),
          borderColor: Color(0x801E6FFF),
          shadows: [BoxShadow(color: Color(0x661E6FFF), offset: Offset(0, 4), blurRadius: 10)],
          insets: [InsetSpec.skeuoOnHighlight],
        );
      case WState.disabled:
        return const SurfaceStyle(color: Prims.ink100, borderColor: Prims.ink200);
      default:
        return const SurfaceStyle(
          gradient: _raisedThumb,
          borderColor: Color(0x0F14161E),
          shadows: [BoxShadow(color: Color(0x2914161E), offset: Offset(0, 4), blurRadius: 10)],
          insets: [InsetSpec.skeuoTopHighlight],
        );
    }
  }

  @override
  Color chipText(WState s) => switch (s) {
        WState.selected => Prims.white,
        WState.disabled => const Color(0xFF9A9DA6),
        _ => Prims.ink900,
      };

  @override
  SurfaceStyle cardGround() => const SurfaceStyle(
        gradient: Prims.skeuoCardGround,
        borderColor: Color(0x0D14161E),
        shadows: Prims.skeuoCardLift,
        insets: [InsetSpec.skeuoCardHighlight, InsetSpec.skeuoCardSeat],
      );

  @override
  Color cardTitleColor() => const Color(0xFF8A7C64);

  @override
  SurfaceStyle previewPanel() => const SurfaceStyle(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3EFE8), Color(0xFFE4DCCE)],
        ),
        shadows: [BoxShadow(color: Color(0x1A14161E), offset: Offset(0, 2), blurRadius: 6)],
        insets: [InsetSpec.skeuoTopHighlight],
      );

  @override
  Color previewCaption() => Prims.ink550;

  @override
  Color previewHairline() => const Color(0x3814161E);
}
