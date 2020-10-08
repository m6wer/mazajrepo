// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

// part 'home_bloc_event.dart';
// part 'home_bloc_state.dart';

// class HomeBlocBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
//   HomeBlocBloc() : super(HomeBlocInitial());

//   @override
//   Stream<HomeBlocState> mapEventToState(
//     HomeBlocEvent event,
//   ) async* {
//     if (event is RefreshOrders) {
//       yield RefreshOrderState();
//     }
//   }
// }
