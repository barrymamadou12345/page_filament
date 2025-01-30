<?php

namespace App\Filament\Pages;

use App\Models\User;
use Filament\Pages\Page;

class UserInfos extends Page
{

    protected static ?string $navigationIcon = 'heroicon-o-document-text';

    protected static string $view = 'filament.pages.user-infos';



    public $user;

    public function mount($userId){
        return $this->user = User::find($userId);
    }


    public static function shouldRegisterNavigation(): bool
    {
        return false;
    }


}
