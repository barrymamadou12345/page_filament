<x-filament-panels::page>


  <h1 class="text-3xl">Voici les Informations de l'utilisateur</h1>

  <div class="flex gap-6">
    <div class="border-2 rounded-xl" style="background-color: orange;width:25%;height:125px;"></div>
    <div class="border-2 rounded-xl" style="background-color: orange;width:25%;height:125px;"></div>
  </div>

  <div class="flex gap-4">
    <p class="text-3xl font-bold" style="color: yellow;">Nom de l'utilisateur :</p>
    <p class="text-3xl">{{ $user->name }}</p>
  </div>
  <div class="flex gap-4">
    <p class="text-3xl font-bold" style="color: yellow;">Email de l'utilisateur :</p>
    <p class="text-3xl">{{ $user->email }}</p>
  </div>
  <div class="flex gap-4">
    <p class="text-3xl font-bold" style="color: yellow;">Téléphone de l'utilisateur :</p>
    <p class="text-3xl">{{ $user->telephone }}</p>
  </div>

</x-filament-panels::page>