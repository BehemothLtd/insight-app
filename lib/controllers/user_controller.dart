import 'package:get/get.dart';
import 'package:insight_app/models/metadata.dart';
import 'package:insight_app/models/pagy_input.dart';

import 'package:insight_app/models/user.dart';
import 'package:insight_app/models/users_query.dart';

class UserController extends GetxController {
  var users = Rxn<List<User>>([]);
  var input = Rxn<PagyInput>(PagyInput(page: 1, perPage: 10));
  var metadata = Rxn<Metadata>(null);
  var usersQuery = Rxn<UsersQuery>(UsersQuery());

  setInput(value) {
    input.value = value;
  }

  setMetadata(value) {
    metadata.value = value;
  }

  increasePage() {
    input.value?.page = (input.value!.page + 1);
  }

  resetPagy() {
    input.value = PagyInput(perPage: 10, page: 1);
    metadata.value = null;
  }

  resetParams() {
    usersQuery.value = UsersQuery();
  }

  fetchUsers(bool isRefresh) async {
    if (input.value != null && metadata.value != null) {
      var maxPages = metadata.value?.pages ?? 10;
      if (input.value!.page > maxPages) {
        return Future.error('No more users to load');
      }
    }

    var result = await User.fetchUsers(input.value, usersQuery.value);

    if (result != null) {
      var list = result["list"];

      Metadata metadata = result["metadata"];

      setMetadata(metadata);
      setInput(
        PagyInput(
          perPage: metadata.perPage ?? 1,
          page: metadata.page ?? 10,
        ),
      );

      if (isRefresh) {
        users.value = result["list"];
      } else {
        if (users.value != null) {
          users.value = [...users.value!, ...list];
        } else {
          users.value = list;
        }
      }
    }
  }
}
