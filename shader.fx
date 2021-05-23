texture wrapTexture;

technique TexReplace
{
    pass P0
    {
        Texture[0] = wrapTexture;
    }
}