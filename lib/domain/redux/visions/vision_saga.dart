import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/vision_entity.dart';
import 'package:teja/domain/redux/visions/vision_action.dart';
import 'package:teja/infrastructure/repositories/vision_respository.dart';

class VisionSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchVisionsFromDatabase, pattern: LoadVisionsAction);
    yield TakeEvery(_toggleVision, pattern: VisionToggleAction);
  }

  _fetchVisionsFromDatabase({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(VisionUpdateInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var visionRepo = VisionRepository(isar);

      var visionsResult = Result<List<VisionEntity>>();
      yield Call(
        visionRepo.getAllVisions,
        result: visionsResult,
      );

      if (visionsResult.value != null && visionsResult.value!.isNotEmpty) {
        yield Put(VisionUpdateSuccessAction(visionsResult.value!));
      } else {
        yield Put(const VisionUpdateFailedAction('Failed to load visions'));
      }
    }, Catch: (e, s) sync* {
      yield Put(VisionUpdateFailedAction(e.toString()));
    });
  }

  _toggleVision({dynamic action}) sync* {
    if (action is VisionToggleAction) {
      yield Try(() sync* {
        yield Put(VisionUpdateInProgressAction());

        var isarResult = Result<Isar>();
        yield GetContext('isar', result: isarResult);
        Isar isar = isarResult.value!;
        var visionRepo = VisionRepository(isar);
        // Determine the isSelected state for the vision
        var currentVisionState = Result<List<VisionEntity>>();
        yield Call(
          visionRepo.getAllVisions,
          result: currentVisionState,
        );
        bool isSelected = !(currentVisionState.value?.any((v) => v.slug == action.visionSlug) ?? false);

        var toggleResult = Result<void>();
        yield Call(
          visionRepo.toggleVision,
          args: [action.visionSlug, isSelected],
          result: toggleResult,
        );

        // Refetch updated visions after toggling
        var updatedVisionsResult = Result<List<VisionEntity>>();
        yield Call(
          visionRepo.getAllVisions,
          result: updatedVisionsResult,
        );

        if (updatedVisionsResult.value != null) {
          yield Put(VisionUpdateSuccessAction(updatedVisionsResult.value!));
        } else {
          yield Put(const VisionUpdateFailedAction('Failed to update visions'));
        }
      }, Catch: (e, s) sync* {
        yield Put(VisionUpdateFailedAction(e.toString()));
      });
    }
  }
}
