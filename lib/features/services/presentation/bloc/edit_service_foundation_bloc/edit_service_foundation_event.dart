part of 'edit_service_foundation_bloc.dart';

abstract class EditServiceFoundationEvent extends Equatable {
  @override
  List<Object> get props => [];

  const EditServiceFoundationEvent();
}

class DoEditServiceForFoundationEvent extends EditServiceFoundationEvent {
  final AddService myService;

  const DoEditServiceForFoundationEvent(this.myService);

  @override
  List<Object> get props => [myService];
}

class StopServiceForFoundationEvent extends EditServiceFoundationEvent {
  final int id;

  const StopServiceForFoundationEvent(this.id);

  @override
  List<Object> get props => [id];
}
